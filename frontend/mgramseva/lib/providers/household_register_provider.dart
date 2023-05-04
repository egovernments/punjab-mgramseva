import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/model/connection/water_connections.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/repository/search_connection_repo.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/screeens/HouseholdRegister/household_pdf.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/ExcelDownload/generate_excel.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/color_codes.dart';
import 'package:mgramseva/utils/constants.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:provider/provider.dart';

class HouseholdRegisterProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();
  TextEditingController searchController = TextEditingController();
  int offset = 1;
  int limit = 10;
  late DateTime selectedDate;
  SortBy? sortBy;
  WaterConnections? waterConnectionsDetails;
  WaterConnection? waterConnection;
  String selectedTab = Constants.ALL;
  Map<String, int> collectionCountHolder = {};
  Timer? debounce;
  bool isLoaderEnabled = false;
  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  onChangeOfTab(BuildContext context, int index) async {
    var householdProvider =
        Provider.of<HouseholdRegisterProvider>(context, listen: false)
          ..limit = 10
          ..offset = 1
          ..sortBy = SortBy('connectionNumber', false);

    householdProvider
      ..waterConnectionsDetails?.waterConnection = <WaterConnection>[]
      ..waterConnectionsDetails?.totalCount = null;

    if (index == 0) {
      householdProvider.selectedTab = Constants.ALL;
    } else if (index == 1) {
      householdProvider.selectedTab = Constants.PAID;
    } else {
      householdProvider.selectedTab = Constants.PENDING;
    }
    householdProvider.fetchHouseholdDetails(
        context, householdProvider.limit, householdProvider.offset, true);
  }

  Future<void> fetchHouseholdDetails(
      BuildContext context, int limit, int offSet,
      [bool isSearch = false]) async {
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);
    var totalCount = waterConnectionsDetails?.totalCount ?? 0;
    this.limit = limit;
    this.offset = offSet;
    notifyListeners();
    if (!isSearch &&
        waterConnectionsDetails?.totalCount != null &&
        ((offSet + limit) > totalCount ? totalCount : (offSet + limit)) <=
            (waterConnectionsDetails?.waterConnection?.length ?? 0)) {
      streamController.add(waterConnectionsDetails?.waterConnection?.sublist(
          offset - 1,
          ((offset + limit) - 1) > totalCount
              ? totalCount
              : (offset + limit) - 1));
      return;
    }

    if (isSearch) waterConnectionsDetails = null;

    var query = {
      'tenantId': commonProvider.userDetails?.selectedtenant?.code,
      'offset': '${offset - 1}',
      'limit': '$limit',
      'toDate': '${DateTime.now().millisecondsSinceEpoch}',
      'isCollectionCount': 'true',
    };

    if (selectedTab != Constants.ALL) {
      query.addAll(
          {'isBillPaid': (selectedTab == Constants.PAID) ? 'true' : 'false'});
    }

    if (sortBy != null) {
      query.addAll({
        'sortOrder': sortBy!.isAscending ? 'ASC' : 'DESC',
        'sortBy': sortBy!.key
      });
    }

    if (searchController.text.trim().isNotEmpty) {
      query.addAll({
        'textSearch': searchController.text.trim(),
        // 'name' : searchController.text.trim(),
        'freeSearch': 'true',
      });
    }

    query
        .removeWhere((key, value) => (value is String && value.trim().isEmpty));
    streamController.add(null);

    isLoaderEnabled = true;
    notifyListeners();
    try {
      var response = await SearchConnectionRepository().getconnection(query);

      var searchResponse;
      if (isSearch && selectedTab != Constants.ALL) {
        query.remove('isBillPaid');
        searchResponse =
            await SearchConnectionRepository().getconnection(query);
      }

      isLoaderEnabled = false;

      if (response != null) {
        if (selectedTab == Constants.ALL) {
          collectionCountHolder[Constants.ALL] = response.totalCount ?? 0;
          collectionCountHolder[Constants.PAID] =
              response.collectionDataCount?.collectionPaid ?? 0;
          collectionCountHolder[Constants.PENDING] =
              response.collectionDataCount?.collectionPending ?? 0;
        } else if (searchResponse != null) {
          collectionCountHolder[Constants.ALL] = searchResponse.totalCount ?? 0;
          collectionCountHolder[Constants.PAID] =
              searchResponse.collectionDataCount?.collectionPaid ?? 0;
          collectionCountHolder[Constants.PENDING] =
              searchResponse.collectionDataCount?.collectionPending ?? 0;
        }

        if (waterConnectionsDetails == null) {
          waterConnectionsDetails = response;
          notifyListeners();
        } else {
          waterConnectionsDetails?.totalCount = response.totalCount;
          waterConnectionsDetails?.waterConnection
              ?.addAll(response.waterConnection ?? <WaterConnection>[]);
        }
        notifyListeners();
        streamController.add(waterConnectionsDetails!.waterConnection!.isEmpty
            ? <WaterConnection>[]
            : waterConnectionsDetails?.waterConnection?.sublist(
                offSet - 1,
                ((offset + limit - 1) >
                        (waterConnectionsDetails?.totalCount ?? 0))
                    ? (waterConnectionsDetails!.totalCount!)
                    : (offset + limit) - 1));
      }
    } catch (e, s) {
      isLoaderEnabled = false;
      notifyListeners();
      streamController.addError('error');
      ErrorHandler().allExceptionsHandler(context, e, s);
    }
  }

  List<String> getCollectionsTabList(BuildContext context) {
    var list = [i18.dashboard.ALL, i18.dashboard.PAID, i18.dashboard.PENDING];
    return List.generate(
        list.length,
        (index) =>
            '${ApplicationLocalizations.of(context).translate(list[index])} (${getCollectionsCount(index)})');
  }

  bool isTabSelected(int index) {
    if (selectedTab == Constants.ALL && index == 0) return true;
    if ((selectedTab == Constants.PENDING && index == 2) ||
        (selectedTab == Constants.PAID && index == 1)) return true;
    return false;
  }

  List<TableHeader> get collectionHeaderList => [
        TableHeader(i18.common.CONNECTION_ID,
            isSortingRequired: true,
            isAscendingOrder:
                sortBy != null && sortBy!.key == 'connectionNumber'
                    ? sortBy!.isAscending
                    : null,
            apiKey: 'connectionNumber',
            callBack: onSort),
        TableHeader(i18.consumer.OLD_CONNECTION_ID,
            isSortingRequired: false,),
        TableHeader(i18.common.NAME,
            isSortingRequired: true,
            isAscendingOrder: sortBy != null && sortBy!.key == 'name'
                ? sortBy!.isAscending
                : null,
            apiKey: 'name',
            callBack: onSort),
        TableHeader(i18.consumer.FATHER_SPOUSE_NAME,
            isSortingRequired: false,
            isAscendingOrder:
                sortBy != null && sortBy!.key == 'fatherOrHusbandName'
                    ? sortBy!.isAscending
                    : null,
            apiKey: 'fatherOrHusbandName',
            callBack: onSort),
        TableHeader(i18.householdRegister.PENDING_COLLECTIONS,
            isSortingRequired: true,
            isAscendingOrder:
                sortBy != null && sortBy!.key == 'collectionPendingAmount'
                    ? sortBy!.isAscending
                    : null,
            apiKey: 'collectionPendingAmount',
            callBack: onSort),
        TableHeader(i18.common.CORE_ADVANCE,
            isSortingRequired: true,
            isAscendingOrder:
                sortBy != null && sortBy!.key == 'collectionPendingAmount'
                    ? sortBy!.isAscending
                    : null,
            apiKey: 'collectionPendingAmount',
            callBack: onSort),
        TableHeader(i18.householdRegister.ACTIVE_INACTIVE, apiKey: 'status'),
        TableHeader(i18.householdRegister.LAST_BILL_GEN_DATE,
            isSortingRequired: true,
            apiKey: 'lastDemandGeneratedDate',
            isAscendingOrder:
                sortBy != null && sortBy!.key == 'lastDemandGeneratedDate'
                    ? sortBy!.isAscending
                    : null,
            callBack: onSort),
      ];

  List<TableDataRow> getCollectionsData(List<WaterConnection> list) {
    return list.map((e) => getCollectionRow(e)).toList();
  }

  getDownloadList() {
    return collectionCountHolder[selectedTab] ?? 0;
  }

  int getCollectionsCount(int index) {
    switch (index) {
      case 0:
        return collectionCountHolder[Constants.ALL] ?? 0;
      case 1:
        return collectionCountHolder[Constants.PAID] ?? 0;
      case 2:
        return collectionCountHolder[Constants.PENDING] ?? 0;
      default:
        return 0;
    }
  }

  String? truncateWithEllipsis(String? myString) {
    return (myString!.length <= 20)
        ? myString
        : '${myString.substring(0, 20)}...';
  }

  TableDataRow getCollectionRow(WaterConnection connection) {
    String? name =
        truncateWithEllipsis(connection.connectionHolders?.first.name);
    String? fatherName = truncateWithEllipsis(
        connection.connectionHolders?.first.fatherOrHusbandName);
    return TableDataRow([
      TableData(
          '${connection.connectionNo?.split('/').first ?? ''}/...${connection.connectionNo?.split('/').last ?? ''} ${connection.connectionType == 'Metered' ? '- M' : ''}',
          callBack: onClickOfCollectionNo,
          apiKey: connection.connectionNo),
      TableData('${connection.oldConnectionNo ?? ''}'),
      TableData('${name ?? ''}'),
      TableData('${fatherName ?? ''}'),
      TableData(
          '${connection.additionalDetails?.collectionPendingAmount != null ? double.parse(connection.additionalDetails?.collectionPendingAmount ?? '') < 0.0 ? '-' : ' ₹ ${connection.additionalDetails?.collectionPendingAmount}' : '-'}'),
      TableData(
          '${connection.additionalDetails?.collectionPendingAmount != null ? double.parse(connection.additionalDetails?.collectionPendingAmount ?? '') < 0.0 ? '- ₹ ${double.parse(connection.additionalDetails?.collectionPendingAmount ?? '').abs()}' : '-' : '-'}'),
      TableData(
          '${connection.status.toString() == Constants.CONNECTION_STATUS.last ? 'Y' : 'N'}',
          style: TextStyle(
              color: connection.status.toString() ==
                      Constants.CONNECTION_STATUS.last
                  ? ColorCodes.ACTIVE_COL
                  : ColorCodes.INACTIVE_COL)),
      TableData(
          '${connection.additionalDetails?.lastDemandGeneratedDate != null && connection.additionalDetails?.lastDemandGeneratedDate != '' ? DateFormats.timeStampToDate(int.parse(connection.additionalDetails?.lastDemandGeneratedDate ?? '')) : '-'}')
    ]);
  }

  onClickOfCollectionNo(TableData tableData) {
    var waterConnection = waterConnectionsDetails?.waterConnection
        ?.firstWhere((element) => element.connectionNo == tableData.apiKey);
    Navigator.pushNamed(navigatorKey.currentContext!, Routes.HOUSEHOLD_DETAILS,
        arguments: {
          'waterconnections': waterConnection,
          'mode': 'collect',
          'status': waterConnection?.status
        });
  }

  onSort(TableHeader header) {
    if (sortBy != null && sortBy!.key == header.apiKey) {
      header.isAscendingOrder = !sortBy!.isAscending;
    } else if (header.isAscendingOrder == null) {
      header.isAscendingOrder = true;
    } else {
      header.isAscendingOrder = !(header.isAscendingOrder ?? false);
    }
    sortBy = SortBy(header.apiKey ?? '', header.isAscendingOrder!);
    notifyListeners();
    fetchHouseholdDetails(navigatorKey.currentContext!, limit, 1, true);
  }

  void onSearch(String val, BuildContext context) {
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      fetchDetails(context, limit, 1, true);
    });
  }

  void onChangeOfPageLimit(PaginationResponse response, BuildContext context) {
    fetchDetails(
        context, response.limit, response.offset, response.isPageChange);
  }

  fetchDetails(BuildContext context,
      [int? localLimit, int? localOffSet, bool isSearch = false]) {
    if (isLoaderEnabled) return;

    fetchHouseholdDetails(
        context, localLimit ?? limit, localOffSet ?? 1, isSearch);
  }

  void createExcelOrPdfForAllConnections(BuildContext context, bool isDownload,
      {bool isExcelDownload = false}) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    WaterConnections? waterConnectionsDetails;

    var query = {
      'tenantId': commonProvider.userDetails?.selectedtenant?.code,
      'limit': '-1',
      'toDate': '${DateTime.now().millisecondsSinceEpoch}',
      'isCollectionCount': 'true',
    };

    if (selectedTab != Constants.ALL) {
      query.addAll(
          {'isBillPaid': (selectedTab == Constants.PAID) ? 'true' : 'false'});
    }

    if (sortBy != null) {
      query.addAll({
        'sortOrder': sortBy!.isAscending ? 'ASC' : 'DESC',
        'sortBy': sortBy!.key
      });
    }

    if (searchController.text.trim().isNotEmpty) {
      query.addAll({
        'textSearch': searchController.text.trim(),
        // 'name' : searchController.text.trim(),
        'freeSearch': 'true',
      });
    }

    query
        .removeWhere((key, value) => (value is String && value.trim().isEmpty));

    Loaders.showLoadingDialog(context);
    try {
      waterConnectionsDetails =
          await SearchConnectionRepository().getconnection(query);

      Navigator.pop(context);
    } catch (e, s) {
      Navigator.pop(context);
      ErrorHandler().allExceptionsHandler(context, e, s);
      return;
    }

    if (waterConnectionsDetails.waterConnection == null ||
        waterConnectionsDetails.waterConnection!.isEmpty) return;

    var headerList = [
      i18.common.CONNECTION_ID,
      i18.consumer.OLD_CONNECTION_ID,
      i18.common.NAME,
      i18.consumer.FATHER_SPOUSE_NAME,
      i18.householdRegister.PENDING_COLLECTIONS,
      i18.common.CORE_ADVANCE,
      i18.householdRegister.ACTIVE_INACTIVE,
      i18.householdRegister.LAST_BILL_GEN_DATE
    ];

    var pdfTableData = waterConnectionsDetails.waterConnection
            ?.map<List<String>>((connection) => [
                  '${connection.connectionNo ?? ''} ${connection.connectionType == 'Metered' ? '- M' : ''}',
                  '${connection.connectionHolders?.first.name ?? ''}',
                  '${connection.connectionHolders?.first.fatherOrHusbandName ?? ''}',
                  '${connection.additionalDetails?.collectionPendingAmount != null ? double.parse(connection.additionalDetails?.collectionPendingAmount ?? '') < 0.0 ? '-' : ' ₹ ${connection.additionalDetails?.collectionPendingAmount}' : '-'}',
                  '${connection.additionalDetails?.collectionPendingAmount != null ? double.parse(connection.additionalDetails?.collectionPendingAmount ?? '') < 0.0 ? '- ₹ ${double.parse(connection.additionalDetails?.collectionPendingAmount ?? '').abs()}' : '₹ 0' : '₹ 0'}',
                  '${connection.status.toString() == Constants.CONNECTION_STATUS.last ? 'Y' : 'N'}',
                  '${connection.additionalDetails?.lastDemandGeneratedDate != null && connection.additionalDetails?.lastDemandGeneratedDate != '' ? DateFormats.timeStampToDate(int.parse(connection.additionalDetails?.lastDemandGeneratedDate ?? '')) : '-'}'
                ])
            .toList() ??
        [];
    var excelTableData = waterConnectionsDetails.waterConnection
            ?.map<List<String>>((connection) => [
                  '${connection.connectionNo ?? ''} ${connection.connectionType == 'Metered' ? '- M' : ''}',
                  '${connection.oldConnectionNo ?? ''}',
                  '${connection.connectionHolders?.first.name ?? ''}',
                  '${connection.connectionHolders?.first.fatherOrHusbandName ?? ''}',
                  '${connection.additionalDetails?.collectionPendingAmount != null ? double.parse(connection.additionalDetails?.collectionPendingAmount ?? '') < 0.0 ? '-' : ' ₹ ${connection.additionalDetails?.collectionPendingAmount}' : '-'}',
                  '${connection.additionalDetails?.collectionPendingAmount != null ? double.parse(connection.additionalDetails?.collectionPendingAmount ?? '') < 0.0 ? '- ₹ ${double.parse(connection.additionalDetails?.collectionPendingAmount ?? '').abs()}' : '₹ 0' : '₹ 0'}',
                  '${connection.status.toString() == Constants.CONNECTION_STATUS.last ? 'Y' : 'N'}',
                  '${connection.additionalDetails?.lastDemandGeneratedDate != null && connection.additionalDetails?.lastDemandGeneratedDate != '' ? DateFormats.timeStampToDate(int.parse(connection.additionalDetails?.lastDemandGeneratedDate ?? '')) : '-'}'
                ])
            .toList() ??
        [];

    isExcelDownload
        ? generateExcel(
        headerList
                .map<String>((e) =>
                    '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(e)}')
                .toList(),
            excelTableData)
        : await HouseholdPdfCreator(
                context,
        headerList.where((e) => e!=i18.consumer.OLD_CONNECTION_ID)
                    .map<String>((e) =>
                        '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(e)}')
                    .toList(),
                pdfTableData,
                isDownload)
            .pdfPreview();
    Navigator.pop(context);
  }

  bool removeOverLay(_overlayEntry) {
    try {
      if (_overlayEntry == null) return false;
      _overlayEntry?.remove();
      return true;
    } catch (e) {
      return false;
    }
  }
}
