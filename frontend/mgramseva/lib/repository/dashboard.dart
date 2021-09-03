import 'package:mgramseva/model/dashboard/expense_dashboard.dart';
import 'package:mgramseva/providers/common_provider.dart';
import 'package:mgramseva/services/base_service.dart';
import 'package:mgramseva/utils/global_variables.dart';
import 'package:provider/provider.dart';

class DashBoardRepository extends BaseService {
  Future<ExpenseDashboard?> loadExpenseDashboardDetails(
      Map<String, dynamic> query) async {
    var commonProvider = Provider.of<CommonProvider>(
        navigatorKey.currentContext!,
        listen: false);
    ExpenseDashboard? expenseDashboard;

    var body = {'userInfo': commonProvider.userDetails?.userRequest?.toJson()};

    // var res = await makeRequest(
    //     url: Url.SEARCH_METER_CONNECTION_DEMAND,
    //     body: body,
    //     queryParameters: query,
    //     method: RequestType.POST,
    //     requestInfo: RequestInfo(
    //       'Rainmaker',
    //       1,
    //       "",
    //       "search",
    //       "",
    //       "",
    //       "",
    //       commonProvider.userDetails!.accessToken,
    //     ));

    dynamic res = a;
    await Future.delayed(Duration(seconds: 2));

    if (res != null) {
      expenseDashboard = ExpenseDashboard.fromJson(res['responseData']);
    }
    return expenseDashboard;
  }
}

var a = {
  "statusInfo": {
    "statusCode": 200,
    "statusMessage": "success",
    "errorMessage": ""
  },
  "responseData": {
    "chartType": "xtable",
    "visualizationCode": "ecpenditureData",
    "chartFormat": null,
    "drillDownChartId": "none",
    "customData": null,
    "dates": null,
    "filter": [
      {"key": "vendor", "column": "Vendor"}
    ],
    "data": [
      {
        "headerName": "EB-2021-22-0104",
        "headerValue": 9,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "9",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0104",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0126",
        "headerValue": 26,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "26",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0126",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0105",
        "headerValue": 10,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "10",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0105",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0127",
        "headerValue": 27,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "27",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0127",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0102",
        "headerValue": 7,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "7",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0102",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0124",
        "headerValue": 24,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "24",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0124",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0146",
        "headerValue": 46,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "46",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0146",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0103",
        "headerValue": 8,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "8",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0103",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0125",
        "headerValue": 25,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "25",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0125",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0147",
        "headerValue": 47,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "47",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0147",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0108",
        "headerValue": 13,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "13",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0108",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0109",
        "headerValue": 14,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "14",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0109",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0106",
        "headerValue": 11,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "11",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0106",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0128",
        "headerValue": 28,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "28",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0128",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0107",
        "headerValue": 12,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "12",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0107",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0129",
        "headerValue": 29,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "29",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0129",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0130",
        "headerValue": 30,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "30",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0130",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0111",
        "headerValue": 16,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "16",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0111",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0133",
        "headerValue": 33,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "33",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0133",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0112",
        "headerValue": 17,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "17",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0112",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0134",
        "headerValue": 34,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "34",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0134",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0098",
        "headerValue": 6,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "6",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0098",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0131",
        "headerValue": 31,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "31",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0131",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0110",
        "headerValue": 15,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "15",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0110",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0132",
        "headerValue": 32,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "32",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0132",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0089",
        "headerValue": 4,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "4",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0089",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0122",
        "headerValue": 22,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "22",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0122",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0144",
        "headerValue": 44,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "44",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0144",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0123",
        "headerValue": 23,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "23",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0123",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0145",
        "headerValue": 45,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "45",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0145",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0142",
        "headerValue": 42,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "42",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0142",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0044",
        "headerValue": 2,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "2",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0044",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0088",
        "headerValue": 3,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "3",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0088",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0143",
        "headerValue": 43,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "43",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0143",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0115",
        "headerValue": 19,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "19",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0115",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0137",
        "headerValue": 37,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "37",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0137",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0039",
        "headerValue": 1,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "1",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0039",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0116",
        "headerValue": 20,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "20",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0116",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0138",
        "headerValue": 38,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "38",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0138",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0113",
        "headerValue": 18,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "18",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0113",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0135",
        "headerValue": 35,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "35",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0135",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0136",
        "headerValue": 36,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "36",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0136",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0117",
        "headerValue": 21,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "21",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0117",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0139",
        "headerValue": 39,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "39",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0139",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0140",
        "headerValue": 40,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "40",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0140",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0141",
        "headerValue": 41,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "41",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0141",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      },
      {
        "headerName": "EB-2021-22-0092",
        "headerValue": 5,
        "headerSymbol": null,
        "insight": null,
        "plots": [
          {
            "label": "5",
            "name": "S.N.",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": "EB-2021-22-0092",
            "name": "Vehicle_No",
            "value": null,
            "strValue": null,
            "symbol": "text"
          },
          {
            "label": null,
            "name": "Expense Type",
            "value": 1.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Amount",
            "value": 0.0,
            "strValue": null,
            "symbol": "number"
          },
          {
            "label": null,
            "name": "Bill Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          },
          {
            "label": null,
            "name": "Paid Date",
            "value": 0.0,
            "strValue": null,
            "symbol": "String"
          }
        ]
      }
    ]
  }
};
