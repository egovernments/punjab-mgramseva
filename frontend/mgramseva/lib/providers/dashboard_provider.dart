import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/model/connection/water_connections.dart';
import 'package:mgramseva/model/dashboard/expense_dashboard.dart';
import 'package:mgramseva/model/expensesDetails/expenses_details.dart';
import 'package:mgramseva/model/mdms/property_type.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/repository/dashboard.dart';
import 'package:mgramseva/repository/expenses_repo.dart';
import 'package:mgramseva/repository/search_connection_repo.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/services/MDMS.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/common_methods.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:mgramseva/utils/models.dart';
import 'package:provider/provider.dart';

class DashBoardProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();
  var initialStreamController = StreamController.broadcast();
  TextEditingController searchController = TextEditingController();
  ExpensesDetailsWithPagination? expenseDashboardDetails;
  int offset = 1;
  int limit = 10;
  late DateTime selectedMonth;
  SortBy? sortBy;
  late List<DateTime> dateList;
  WaterConnections? waterConnectionsDetails;
  var selectedDashboardType = DashBoardType.collections;
  String selectedTab = 'all';
  Map<String, int> expenditureCountHolder= {};
  Map<String, int> collectionCountHolder= {};
  Timer? debounce;
  List<PropertyType> propertyTaxList = <PropertyType>[];
  bool isLoaderEnabled = false;

  @override
  void dispose() {
    streamController.close();
    initialStreamController.close();
    super.dispose();
  }



  fetchData() async {
    var commonProvider = Provider.of<CommonProvider>(navigatorKey.currentContext!, listen: false);

    if (propertyTaxList.isEmpty) {
      var languageList = await CoreRepository().getMdms(
          getServiceTypeConnectionTypePropertyTypeMDMS(
              commonProvider.userDetails!.userRequest!.tenantId.toString()));

      if (languageList.mdmsRes?.propertyTax?.PropertyTypeList != null) {
        var property = PropertyType();
        property.code = i18.dashboard.ALL;
        propertyTaxList.add(property);
        propertyTaxList.addAll(
            languageList.mdmsRes?.propertyTax?.PropertyTypeList ??
                <PropertyType>[]);
      }
    }else{
      await Future.delayed(Duration(seconds: 1));
    }
    initialStreamController.add([]);
  }

  Future<void> fetchExpenseDashBoardDetails(
      BuildContext context, int limit, int offSet,
      [bool isSearch = false]) async {
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);
    var totalCount = expenseDashboardDetails?.totalCount ?? 0;
    this.limit = limit;
    this.offset = offSet;
    notifyListeners();
    if (!isSearch &&
        expenseDashboardDetails?.totalCount != null &&
        ((offSet + limit) > totalCount ? totalCount : (offSet + limit)) <=
            (expenseDashboardDetails?.expenseDetailList?.length ?? 0)) {
      streamController.add(expenseDashboardDetails?.expenseDetailList?.sublist(
          offset - 1,
          ((offset + limit) - 1) > totalCount
              ? totalCount
              : (offset + limit) - 1));
      return;
    }

    if (isSearch) expenseDashboardDetails = null;

    var query = {
      'tenantId': commonProvider.userDetails?.selectedtenant?.code,
      'offset': '${offset - 1}',
      'limit': '$limit',
      'fromDate':
          '${DateTime(selectedMonth.year, selectedMonth.month, 1).millisecondsSinceEpoch}',
      'toDate':
          '${DateTime(selectedMonth.year, selectedMonth.month + 1, 0, 23,59, 59, 999).millisecondsSinceEpoch}',
      'vendorName': searchController.text.trim(),
      'challanNo': searchController.text.trim(),
      'freeSearch': 'true',
      'status': ["ACTIVE", "PAID"],
      'isBillCount': 'true'
    };

    if (sortBy != null) {
      query.addAll({
        'sortOrder': sortBy!.isAscending ? 'ASC' : 'DESC',
        'sortBy': sortBy!.key
      });
    }

    if(selectedTab != 'all'){
    query['isBillPaid'] = ((selectedTab == 'ACTIVE') ? 'false' : 'true');
    };

    query
        .removeWhere((key, value) => (value is String && value.trim().isEmpty));
    streamController.add(null);
    isLoaderEnabled = true;
    notifyListeners();
    try {
      var response = await ExpensesRepository().expenseDashboard(query);

      var searchResponse;
      if(isSearch && selectedTab != 'all'){
        query.remove('isBillPaid');
        searchResponse = await ExpensesRepository().expenseDashboard(query);
      }

      isLoaderEnabled = false;

      if (selectedDashboardType != DashBoardType.Expenditure) return;

      if (response != null) {
        if(selectedTab == 'all'){
        expenditureCountHolder['all'] = response.totalCount ?? 0;
        expenditureCountHolder['pending'] = int.parse(response.billDataCount?.notPaidCount ?? '0');
        expenditureCountHolder['paid'] = int.parse(response.billDataCount?.paidCount ?? '0');
         }else if(searchResponse != null){
          expenditureCountHolder['all'] = searchResponse.totalCount ?? 0;
          expenditureCountHolder['pending'] = int.parse(searchResponse.billDataCount?.notPaidCount ?? '0');
          expenditureCountHolder['paid'] = int.parse(searchResponse.billDataCount?.paidCount ?? '0');
        }

        if (expenseDashboardDetails == null) {
          expenseDashboardDetails = response;
          notifyListeners();
        } else {
          expenseDashboardDetails?.totalCount = response.totalCount;
          expenseDashboardDetails?.expenseDetailList
              ?.addAll(response.expenseDetailList ?? <ExpensesDetailsModel>[]);
        }
        notifyListeners();
        streamController.add(
            expenseDashboardDetails!.expenseDetailList!.isEmpty
                ? <ExpensesDetailsModel>[]
                : expenseDashboardDetails?.expenseDetailList?.sublist(
                    offSet - 1,
                    ((offset + limit - 1) >
                            (expenseDashboardDetails?.totalCount ?? 0))
                        ? (expenseDashboardDetails!.totalCount!)
                        : (offset + limit - 1)));
      }
    } catch (e, s) {
      isLoaderEnabled = false;
      notifyListeners();
      streamController.addError('error');
      ErrorHandler().allExceptionsHandler(context, e, s);
    }
  }

  Future<void> fetchCollectionsDashBoardDetails(
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
      'fromDate':
          '${DateTime(selectedMonth.year, selectedMonth.month, 1).millisecondsSinceEpoch}',
      'toDate':
          '${DateTime(selectedMonth.year, selectedMonth.month + 1, 0,  0, 23,59, 59, 999).millisecondsSinceEpoch}',
      'iscollectionAmount': 'true',
      'isPropertyCount': 'true',
    };

    if(selectedTab != 'all'){
      query['propertyType'] = selectedTab;
    };

    if (sortBy != null) {
      query.addAll({
        'sortOrder': sortBy!.isAscending ? 'ASC' : 'DESC',
        'sortBy': sortBy!.key
      });
    }

    if (searchController.text.trim().isNotEmpty) {
      query.addAll({
        'connectionNumber': searchController.text.trim(),
        // 'name' : searchController.text.trim(),
        'freeSearch': 'true',
      });
    }

    // query.removeWhere((key, value) => (value is String && value.trim().isEmpty));
    streamController.add(null);

    try {
      isLoaderEnabled = true;
      notifyListeners();
      var response = await SearchConnectionRepository().getconnection(query);

      var searchResponse;
      if(isSearch && selectedTab != 'all'){
        query.remove('propertyType');
        searchResponse = await SearchConnectionRepository().getconnection(query);
      }

      isLoaderEnabled = false;
      if (selectedDashboardType != DashBoardType.collections) return;
      if (response != null) {
        if (waterConnectionsDetails == null) {
          waterConnectionsDetails = response;

          if(selectedTab == 'all'){
            collectionCountHolder['all'] = response.totalCount ?? 0;
            propertyTaxList.forEach((key) {
              collectionCountHolder[key.code!] = int.parse(response.tabData?[key.code!] ?? '0');
            });
          }else if(searchResponse != null){
            collectionCountHolder['all'] = searchResponse.totalCount ?? 0;
            propertyTaxList.forEach((key) {
              collectionCountHolder[key.code!] = int.parse(searchResponse.tabData?[key.code!] ?? '0');
            });
          }

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

  List<Tab> getExpenseTabList(
      BuildContext context) {
    var list = [i18.dashboard.ALL, i18.dashboard.PAID, i18.dashboard.PENDING];
    return List.generate(
        list.length,
        (index) => Tab(
            text:
                '${ApplicationLocalizations.of(context).translate(list[index])} (${getExpenseCount(index)})'));
  }

  List<Tab> getCollectionsTabList(
      BuildContext context) {
    return List.generate(
        propertyTaxList.length,
        (index) => Tab(
            text:
                '${ApplicationLocalizations.of(context).translate(propertyTaxList[index].code ?? '')} (${getCollectionsCount(index)})'));
  }

  List<TableHeader> get expenseHeaderList => [
        TableHeader(i18.dashboard.BILL_ID_VENDOR,
            isSortingRequired: true,
            isAscendingOrder: sortBy != null && sortBy!.key == 'challanno'
                ? sortBy!.isAscending
                : null,
            callBack: onExpenseSort,
            apiKey: 'challanno'),
        TableHeader(i18.expense.EXPENSE_TYPE,
            isSortingRequired: true,
            isAscendingOrder: sortBy != null && sortBy!.key == 'typeOfExpense'
                ? sortBy!.isAscending
                : null,
            apiKey: 'typeOfExpense',
            callBack: onExpenseSort),
        TableHeader(i18.common.AMOUNT,
            isSortingRequired: true,
            isAscendingOrder: sortBy != null && sortBy!.key == 'totalAmount'
                ? sortBy!.isAscending
                : null,
            apiKey: 'totalAmount',
            callBack: onExpenseSort),
        TableHeader(i18.expense.BILL_DATE,
            isSortingRequired: true,
            isAscendingOrder: sortBy != null && sortBy!.key == 'billDate'
                ? sortBy!.isAscending
                : null,
            apiKey: 'billDate',
            callBack: onExpenseSort),
        TableHeader(i18.common.PAID_DATE,
            isSortingRequired: true,
            isAscendingOrder: sortBy != null && sortBy!.key == 'paidDate'
                ? sortBy!.isAscending
                : null,
            apiKey: 'paidDate',
            callBack: onExpenseSort),
      ];

  List<TableHeader> get collectionHeaderList => [
        TableHeader(i18.common.CONNECTION_ID,
            isSortingRequired: true,
            isAscendingOrder:
                sortBy != null && sortBy!.key == 'connectionNumber'
                    ? sortBy!.isAscending
                    : null,
            apiKey: 'connectionNumber ',
            callBack: onExpenseSort),
        TableHeader(i18.common.NAME,
            isSortingRequired: true,
            isAscendingOrder: sortBy != null && sortBy!.key == 'name'
                ? sortBy!.isAscending
                : null,
            apiKey: 'name',
            callBack: onExpenseSort),
        TableHeader(i18.dashboard.COLLECTIONS,
            isSortingRequired: true,
            isAscendingOrder:
                sortBy != null && sortBy!.key == 'collectionAmount'
                    ? sortBy!.isAscending
                    : null,
            apiKey: 'collectionAmount',
            callBack: onExpenseSort),
      ];

  List<TableDataRow> getExpenseData(
      int index, List<ExpensesDetailsModel> list) {
    return list.map((e) => getExpenseRow(e)).toList();
  }

  int getExpenseCount(int index) {
    switch (index) {
      case 0:
        return expenditureCountHolder['all'] ?? 0;
      case 1:
        return
            expenditureCountHolder['paid'] ?? 0;
      case 2:
        return
          expenditureCountHolder['pending'] ?? 0;
      default:
        return 0;
    }
  }

  List<TableDataRow> getCollectionsData(int index, List<WaterConnection> list) {
    return list.map((e) => getCollectionRow(e)).toList();
  }

  int getCollectionsCount(int index) {
    switch (index) {
      case 0:
        return collectionCountHolder['all'] ?? 0;
      default:
        return collectionCountHolder[propertyTaxList[index].code] ?? 0;
    }
  }

  TableDataRow getExpenseRow(ExpensesDetailsModel expense) {
    return TableDataRow([
      TableData('${expense.challanNo} \n ${expense.vendorName}',
          callBack: onClickOfChallanNo, apiKey: expense.challanNo),
      TableData('${expense.expenseType}'),
      TableData('₹ ${expense.totalAmount ?? '-'}'),
      TableData('${DateFormats.timeStampToDate(expense.billDate)}'),
      TableData(
          '${expense.paidDate != null && expense.paidDate != 0 ? DateFormats.timeStampToDate(expense.paidDate) : (ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.dashboard.PENDING))}',
          style: expense.paidDate != null && expense.paidDate != 0
              ? null
              : TextStyle(color: Colors.red)),
    ]);
  }

  TableDataRow getCollectionRow(WaterConnection connection) {
    return TableDataRow([
      TableData(
          '${connection.connectionNo?.split('/').first ?? ''}/...${connection.connectionNo?.split('/').last ?? ''} ${connection.connectionType == 'Metered' ? '- M' : ''}',
          callBack: onClickOfCollectionNo,
          apiKey: connection.connectionNo),
      TableData('${connection.connectionHolders?.first.name ?? ''}'),
      TableData(
          '${connection.additionalDetails?.collectionAmount != null ? '₹ ${connection.additionalDetails?.collectionAmount}' : '-'}'),
    ]);
  }

  onClickOfChallanNo(TableData tableData) {
    var expense = expenseDashboardDetails?.expenseDetailList
        ?.firstWhere((element) => element.challanNo == tableData.apiKey);
    Navigator.pushNamed(navigatorKey.currentContext!, Routes.EXPENSE_UPDATE,
        arguments: expense);
  }

  onClickOfCollectionNo(TableData tableData) {
    var waterConnection = waterConnectionsDetails?.waterConnection
        ?.firstWhere((element) => element.connectionNo == tableData.apiKey);
    Navigator.pushNamed(navigatorKey.currentContext!, Routes.HOUSEHOLD_DETAILS,
        arguments: {'waterconnections': waterConnection, 'mode': 'collect'});
  }

  onExpenseSort(TableHeader header) {
    if (sortBy != null && sortBy!.key == header.apiKey) {
      header.isAscendingOrder = !sortBy!.isAscending;
    } else if (header.isAscendingOrder == null) {
      header.isAscendingOrder = true;
    } else {
      header.isAscendingOrder = !(header.isAscendingOrder ?? false);
    }
    sortBy = SortBy(header.apiKey ?? '', header.isAscendingOrder!);
    notifyListeners();
    if (selectedDashboardType == DashBoardType.Expenditure) {
      fetchExpenseDashBoardDetails(
          navigatorKey.currentContext!, limit, 1, true);
    } else {
      fetchCollectionsDashBoardDetails(
          navigatorKey.currentContext!, limit, 1, true);
    }
  }

  void onSearch(String val, BuildContext context) {
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      print('search');
      fetchDetails(context, limit, 1, true);
    });
  }

  void onChangeOfDate(DateTime? date, BuildContext context, _overlayEntry) {
    selectedMonth = date ?? DateTime.now();
    notifyListeners();
    removeOverLay(_overlayEntry);
    fetchDetails(context, limit, 1, true);
  }

  void onChangeOfPageLimit(PaginationResponse response, BuildContext context) {
    fetchDetails(context, response.limit, response.offset);
  }

  fetchDetails(BuildContext context,
      [int? localLimit, int? localOffSet, bool isSearch = false]) {
    if(isLoaderEnabled) return;

    if (selectedDashboardType == DashBoardType.Expenditure) {
      fetchExpenseDashBoardDetails(
          context, localLimit ?? limit, localOffSet ?? 1, isSearch);
    } else {
      fetchCollectionsDashBoardDetails(
          context, localLimit ?? limit, localOffSet ?? 1, isSearch);
    }
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
