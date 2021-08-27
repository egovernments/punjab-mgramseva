import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgramseva/model/bill/bill_generation_details/bill_generation_details.dart';
import 'package:mgramseva/model/bill/billing.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
import 'package:mgramseva/model/localization/language.dart';
import 'package:mgramseva/model/mdms/connection_type.dart';
import 'package:mgramseva/model/mdms/property_type.dart';
import 'package:mgramseva/model/mdms/tax_head_master.dart';
import 'package:mgramseva/model/mdms/tax_period.dart';
import 'package:mgramseva/model/success_handler.dart';
import 'package:mgramseva/repository/bill_generation_details_repo.dart';
import 'package:mgramseva/repository/billing_service_repo.dart';
import 'package:mgramseva/repository/core_repo.dart';
import 'package:mgramseva/repository/search_connection_repo.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/services/MDMS.dart';
import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/date_formats.dart';
import 'package:mgramseva/utils/error_logging.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:mgramseva/utils/loaders.dart';
import 'package:mgramseva/utils/notifyers.dart';
import 'package:mgramseva/widgets/CommonSuccessPage.dart';
import 'package:mgramseva/widgets/ErrorMessagePAge.dart';
import 'package:provider/provider.dart';

import 'common_provider.dart';

class BillGenerationProvider with ChangeNotifier {
  var streamController = StreamController.broadcast();
  LanguageList? languageList;
  late GlobalKey<FormState> formKey;
  var autoValidation = false;
  late BillGenerationDetails billGenerateDetails;
  var waterconnection = WaterConnection();
  late BillList billList;
  late List dates = [];
  var selectedBillYear;
  var selectedBillPeriod;
  var selectedBillCycle;
  var meterReadingDate;
  var prevReadingDate;
  List months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  setModel(String? id, WaterConnection? waterConnection,
      BuildContext context) async {
    billGenerateDetails = BillGenerationDetails();
    billGenerateDetails.serviceCat = "WS_CHARGE";

    billGenerateDetails.meterReadingDateCtrl.text =
        DateFormats.timeStampToDate(DateFormats.dateToTimeStamp(
      DateFormats.getFilteredDate(
        DateTime.now().toLocal().toString(),
      ),
    ));
    if (id == null) {
      billGenerateDetails.serviceType = 'Non Metered';
    }
    if (waterConnection == null) {
      var commonProvider = Provider.of<CommonProvider>(
          navigatorKey.currentContext!,
          listen: false);
      id!.split('_').join('/');
      try {
        Loaders.showLoadingDialog(context);

        var res = await SearchConnectionRepository().getconnection({
          "tenantId": commonProvider.userDetails!.selectedtenant!.code,
          ...{'connectionNumber': id!.split('_').join('/')},
        });

        fetchBill(res.waterConnection!.first);

        Navigator.pop(context);
        waterconnection = res.waterConnection!.first;
        billGenerateDetails.propertyType =
            waterconnection!.additionalDetails!.propertyType;
        billGenerateDetails.serviceType = waterconnection.connectionType;
        if (waterconnection.connectionType == 'Metered') {
          waterconnection = res.waterConnection!.first;
          var meterRes = await BillGenerateRepository().searchmetetedDemand({
            "tenantId": commonProvider.userDetails!.selectedtenant!.code,
            ...{'connectionNos': id!.split('_').join('/')},
          });
          setMeterReading(meterRes);
          if (meterRes.meterReadings!.length == 0) {
            prevReadingDate = waterConnection!.previousReadingDate;
          }
        }
      } catch (e, s) {
        Navigator.pop(context);
        ErrorHandler().allExceptionsHandler(context, e, s);
      }
    } else {
      billGenerateDetails.propertyType =
          waterConnection!.additionalDetails!.propertyType;
      billGenerateDetails.serviceType = waterConnection.connectionType;
      billGenerateDetails.meterNumberCtrl.text = waterConnection.meterId!;
      waterconnection = waterConnection;
      if (waterconnection.connectionType == 'Metered') {
        var commonProvider = Provider.of<CommonProvider>(
            navigatorKey.currentContext!,
            listen: false);
        var meterRes = await BillGenerateRepository().searchmetetedDemand({
          "tenantId": commonProvider.userDetails!.selectedtenant!.code,
          ...{'connectionNos': id!.split('_').join('/')},
        });
        setMeterReading(meterRes);
        if (meterRes.meterReadings!.length == 0) {
          prevReadingDate = waterConnection!.previousReadingDate;
        }
      } else {}
    }
  }

  setMeterReading(meterRes) {
    if (meterRes.meterReadings!.length > 0) {
      billGenerateDetails.meterNumberCtrl.text = waterconnection.meterId!;
      billGenerateDetails.om_1Ctrl.text =
          meterRes.meterReadings!.first.currentReading.toString()[0];
      billGenerateDetails.om_2Ctrl.text =
          meterRes.meterReadings!.first.currentReading.toString()[1];
      billGenerateDetails.om_3Ctrl.text =
          meterRes.meterReadings!.first.currentReading.toString()[2];
      billGenerateDetails.om_4Ctrl.text =
          meterRes.meterReadings!.first.currentReading.toString()[3];
      billGenerateDetails.om_5Ctrl.text =
          meterRes.meterReadings!.first.currentReading.toString()[4];
      prevReadingDate = meterRes.meterReadings!.first.currentReadingDate;
    } else if (waterconnection.additionalDetails!.meterReading != null) {
      billGenerateDetails.om_1Ctrl.text =
          waterconnection.additionalDetails!.meterReading.toString()[0];
      billGenerateDetails.om_2Ctrl.text =
          waterconnection.additionalDetails!.meterReading.toString()[1];
      billGenerateDetails.om_3Ctrl.text =
          waterconnection.additionalDetails!.meterReading.toString()[2];
      billGenerateDetails.om_4Ctrl.text =
          waterconnection.additionalDetails!.meterReading.toString()[3];
      billGenerateDetails.om_5Ctrl.text =
          waterconnection.additionalDetails!.meterReading.toString()[4];
    }
  }

  dispose() {
    streamController.close();
    super.dispose();
  }

  onChangeOfServiceType(val) {
    billGenerateDetails.serviceType = val;
    notifyListeners();
  }

  onChangeOfServiceCat(val) {
    billGenerateDetails.serviceCat = val;
    notifyListeners();
  }

  onChangeOfProperty(val) {
    billGenerateDetails.propertyType = val;
    notifyListeners();
  }

  void onChangeOfBillYear(val) {
    selectedBillYear = val;
    billGenerateDetails.billYear = selectedBillYear;
    notifyListeners();
  }

  void onChangeOfBillCycle(val) {
    selectedBillCycle = (DateFormats.getMonthAndNextMonth(val));
    selectedBillPeriod = (DateFormats.getFilteredDate(val.toLocal().toString(),
            dateFormat: "dd/MM/yyyy")) +
        "-" +
        DateFormats.getFilteredDate(
            (new DateTime(val.year, val.month + 1, val.day))
                .toLocal()
                .toString(),
            dateFormat: "dd/MM/yyyy");
    billGenerateDetails.billCycle = val;
    notifyListeners();
  }

  void onChangeOfDate(value) {
    notifyListeners();
  }

  void onClickOfCollectPayment(Bill bill, BuildContext context) {
    var commonProvider = Provider.of<CommonProvider>(context, listen: false);

    Map<String, dynamic> query = {
      'consumerCode': bill.consumerCode,
      'businessService': bill.businessService,
      'tenantId': commonProvider.userDetails?.selectedtenant?.code
    };
    Navigator.pushNamed(context, Routes.HOUSEHOLD_DETAILS_COLLECT_PAYMENT,
        arguments: query);
  }

  Future<void> getServiceTypePropertyTypeandConnectionType() async {
    try {
      var commonProvider = Provider.of<CommonProvider>(
          navigatorKey.currentContext!,
          listen: false);
      var res = await CoreRepository().getMdms(
          getServiceTypeConnectionTypePropertyTypeMDMS(
              commonProvider.userDetails!.userRequest!.tenantId.toString()));
      languageList = res;
      streamController.add(billGenerateDetails);
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchBill(data) async {
    await BillingServiceRepository().fetchdBill({
      "tenantId": data.tenantId,
      "consumerCode": data.connectionNo.toString(),
      "businessService": "WS"
    }).then((value) => billList = value);
  }

  void onSubmit(context) async {
    if (formKey.currentState!.validate() &&
        billGenerateDetails.serviceType == "Metered") {
      if (billGenerateDetails.om_1Ctrl.text.isEmpty ||
          billGenerateDetails.om_2Ctrl.text.isEmpty ||
          billGenerateDetails.om_3Ctrl.text.isEmpty ||
          billGenerateDetails.om_4Ctrl.text.isEmpty ||
          billGenerateDetails.om_5Ctrl.text.isEmpty) {
        Notifiers.getToastMessage(
            context, i18.demandGenerate.OLD_METER_READING_INVALID, 'ERROR');
      } else if (billGenerateDetails.nm_1Ctrl.text.isEmpty ||
          billGenerateDetails.nm_2Ctrl.text.isEmpty ||
          billGenerateDetails.nm_3Ctrl.text.isEmpty ||
          billGenerateDetails.nm_4Ctrl.text.isEmpty ||
          billGenerateDetails.nm_5Ctrl.text.isEmpty) {
        Notifiers.getToastMessage(
            context, i18.demandGenerate.NEW_METER_READING_INVALID, 'ERROR');
      } else {
        var oldMeter = billGenerateDetails.om_1Ctrl.text +
            billGenerateDetails.om_2Ctrl.text +
            billGenerateDetails.om_3Ctrl.text +
            billGenerateDetails.om_4Ctrl.text +
            billGenerateDetails.om_5Ctrl.text;
        var newMeter = billGenerateDetails.nm_1Ctrl.text +
            billGenerateDetails.nm_2Ctrl.text +
            billGenerateDetails.nm_3Ctrl.text +
            billGenerateDetails.nm_4Ctrl.text +
            billGenerateDetails.nm_5Ctrl.text;
        if (int.parse(oldMeter) < int.parse(newMeter)) {
          try {
            Loaders.showLoadingDialog(context);
            var commonProvider = Provider.of<CommonProvider>(
                navigatorKey.currentContext!,
                listen: false);
            var res1 = {
              "meterReadings": {
                "currentReading": int.parse(newMeter),
                "currentReadingDate": DateFormats.dateToTimeStamp(
                    billGenerateDetails.meterReadingDateCtrl.text),
                "billingPeriod":
                    "${DateFormats.timeStampToDate(prevReadingDate)} - ${DateFormats.timeStampToDate(DateFormats.dateToTimeStamp(billGenerateDetails.meterReadingDateCtrl.text))}",
                "meterStatus": "Working",
                "connectionNo": waterconnection.connectionNo,
                "lastReading": int.parse(oldMeter),
                "lastReadingDate": waterconnection.previousReadingDate,
                "generateDemand": true,
                "tenantId": commonProvider.userDetails!.selectedtenant!.code
              }
            };
            var billResponse1 =
                await BillGenerateRepository().calculateMeterConnection(res1);
            Navigator.pop(context);
            if (billResponse1 != null) {
              Navigator.of(context).pushReplacement(
                  new MaterialPageRoute(builder: (BuildContext context) {
                return CommonSuccess(
                  SuccessHandler(
                      ApplicationLocalizations.of(context)
                          .translate(i18.demandGenerate.GENERATE_BILL_SUCCESS),
                      '${ApplicationLocalizations.of(context).translate(i18.demandGenerate.GENERATE_BILL_SUCCESS_SUBTEXT)}'
                      ' (+91-${billList.bill!.first.mobileNumber})',
                      ApplicationLocalizations.of(context)
                          .translate(i18.common.COLLECT_PAYMENT),
                      Routes.BILL_GENERATE,
                      downloadLink: '',
                      downloadLinkLabel: ApplicationLocalizations.of(context)
                          .translate(i18.common.DOWNLOAD),
                      whatsAppShare: '',
                      subHeader: '${ApplicationLocalizations.of(context).translate(i18.demandGenerate.BILL_ID_NO)}',
                      subHeaderText: '${billList.bill!.first.billNumber.toString()}'),
                  callBack: () =>
                      onClickOfCollectPayment(billList.bill!.first, context),
                  backButton: true,
                );
              }));
            }
          } catch (e) {
            Navigator.pop(context);
            Navigator.of(context).pushReplacement(
                new MaterialPageRoute(builder: (BuildContext context) {
              return ErrorPage(e.toString());
            }));
          }
        } else {
          Notifiers.getToastMessage(
              context, i18.demandGenerate.NEW_METER_READING_INVALID, 'ERROR');
        }
      }
    } else if (formKey.currentState!.validate() &&
        billGenerateDetails.serviceType == "Non Metered") {
      try {
        Loaders.showLoadingDialog(context);
        var commonProvider = Provider.of<CommonProvider>(
            navigatorKey.currentContext!,
            listen: false);
        var res2 = {
          "tenantId": commonProvider.userDetails!.selectedtenant!.code,
          "billingPeriod": selectedBillPeriod
        };
        var billResponse2 = await BillGenerateRepository().bulkDemand(res2);
        Navigator.pop(context);
        if (billResponse2 != null) {
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (BuildContext context) {
            return CommonSuccess(SuccessHandler(
                ApplicationLocalizations.of(context)
                    .translate(i18.demandGenerate.GENERATE_DEMAND_SUCCESS),
                ApplicationLocalizations.of(context).translate(
                        i18.demandGenerate.GENERATE_DEMAND_SUCCESS_SUBTEXT) +
                    ' $selectedBillCycle' +
                    ' ${selectedBillYear.financialYear!.toString().substring(2)}. ' +
                    ApplicationLocalizations.of(context).translate(i18
                        .demandGenerate.GENERATE_DEMAND_SUCCESS_NEXT_SUBTEXT),
                i18.common.BACK_HOME,
                Routes.BILL_GENERATE,
                subHeader: '${ApplicationLocalizations.of(context).translate(i18.demandGenerate.BILLING_CYCLE_LABEL)}',
                subHeaderText: '$selectedBillCycle' + ' ${selectedBillYear.financialYear!.toString().substring(2)}',
            ));
          }));
        }
      } catch (e) {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (BuildContext context) {
          return ErrorPage(e.toString());
        }));
      }
    } else {
      autoValidation = true;
      notifyListeners();
    }
  }

  List<DropdownMenuItem<Object>> getPropertyTypeList() {
    if (languageList?.mdmsRes?.propertyTax?.PropertyTypeList != null) {
      return (languageList?.mdmsRes?.propertyTax?.PropertyTypeList ??
              <PropertyType>[])
          .map((value) {
        return DropdownMenuItem(
          value: value.code,
          child: new Text(value.name!),
        );
      }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }

  List<DropdownMenuItem<Object>> getConnectionTypeList() {
    if (languageList?.mdmsRes?.connection?.connectionTypeList != null) {
      return (languageList?.mdmsRes?.connection?.connectionTypeList ??
              <ConnectionType>[])
          .map((value) {
        return DropdownMenuItem(
          value: value.code,
          child: new Text(value.name!),
        );
      }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }

  List<DropdownMenuItem<Object>> getFinancialYearList() {
    if (languageList?.mdmsRes?.billingService?.taxPeriodList != null) {
      return (languageList?.mdmsRes?.billingService?.taxPeriodList ??
              <TaxPeriod>[])
          .map((value) {
        return DropdownMenuItem(
          value: value,
          child: new Text(value.financialYear!),
        );
      }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }

  List<DropdownMenuItem<Object>> getServiceCategoryList() {
    if (languageList?.mdmsRes?.billingService?.taxHeadMasterList != null) {
      return (languageList?.mdmsRes?.billingService?.taxHeadMasterList ??
              <TaxHeadMaster>[])
          .map((value) {
        return DropdownMenuItem(
          value: value.code,
          child: new Text(value.name!),
        );
      }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }

  List<DropdownMenuItem<Object>> getBillingCycle() {
    dates = [];
    if (billGenerateDetails.billYear != null && selectedBillYear != null) {
      var date2 = DateFormats.getFormattedDateToDateTime(
          DateFormats.timeStampToDate(DateTime.now().millisecondsSinceEpoch));
      var date1 = DateFormats.getFormattedDateToDateTime(
          DateFormats.timeStampToDate(selectedBillYear.fromDate));
      var d = date2 as DateTime;
      var now = date1 as DateTime;
      var days = d.day - now.day;
      var years = d.year - now.year;
      var months = d.month - now.month;
      if (months < 0 || (months == 0 && days < 0)) {
        years--;
        months += (days < 0 ? 11 : 12);
      }
      for (var i = 0; i < months; i++) {
        var prevMonth = new DateTime(now.year, date1.month + i, 1);
        var r = {"code": prevMonth, "name": prevMonth};
        dates.add(r);
      }
    }
    if (dates.length > 0) {
      return (dates ?? <Map>[]).map((value) {
        var d = value['name'] as DateTime;
        return DropdownMenuItem(
          value: value['code'],
          child: new Text(months[d.month - 1] +
              " - " +
              d.year.toString()),
        );
      }).toList();
    }
    return <DropdownMenuItem<Object>>[];
  }
}
