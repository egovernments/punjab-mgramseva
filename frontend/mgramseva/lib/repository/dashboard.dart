import 'package:mgramseva/model/dashboard/revenue_dashboard.dart';
import 'package:mgramseva/services/base_service.dart';

class DashBoardRepository extends BaseService {

  Future<List<Revenue>?> fetchRevenueDetails() async {
    var response = a['responseData']
        .map<Revenue>((e) => Revenue.fromJson(e))
        .toList();
    return response;
  }

  dynamic a = {
    "statusInfo": {
      "statusCode": 200,
      "statusMessage": "success",
      "errorMessage": ""
    },
    "responseData" : [
      {
        "month" : "August",
        "surplus" : 1200,
        "demand" : 123,
        "arrears" : 456,
        "pendingCollections" : 2345,
        "actualCollection" : 576787,
        "expenditure" : 343434,
        "pendingExpendtiure" : 443545,
        "actualPayment" : 35435
      },
      {
        "month" : "September",
        "surplus" : 1200,
        "demand" : 123,
        "arrears" : 456,
        "pendingCollections" : 2345,
        "actualCollection" : 576787,
        "expenditure" : 343434,
        "pendingExpendtiure" : 443545,
        "actualPayment" : 35435
      },
      {
        "month" : "October",
        "surplus" : 1200,
        "demand" : 123,
        "arrears" : 456,
        "pendingCollections" : 2345,
        "actualCollection" : 576787,
        "expenditure" : 343434,
        "pendingExpendtiure" : 443545,
        "actualPayment" : 35435
      },
      {
        "month" : "November",
        "surplus" : 1200,
        "demand" : 123,
        "arrears" : 456,
        "pendingCollections" : 2345,
        "actualCollection" : 576787,
        "expenditure" : 343434,
        "pendingExpendtiure" : 443545,
        "actualPayment" : 35435
      },
      {
        "month" : "December",
        "surplus" : 1200,
        "demand" : 123,
        "arrears" : 456,
        "pendingCollections" : 2345,
        "actualCollection" : 576787,
        "expenditure" : 343434,
        "pendingExpendtiure" : 443545,
        "actualPayment" : 35435
      },
      {
        "month" : "January",
        "surplus" : 1200,
        "demand" : 123,
        "arrears" : 456,
        "pendingCollections" : 2345,
        "actualCollection" : 576787,
        "expenditure" : 343434,
        "pendingExpendtiure" : 443545,
        "actualPayment" : 35435
      },
      {
        "month" : "February",
        "surplus" : 1200,
        "demand" : 123,
        "arrears" : 456,
        "pendingCollections" : 2345,
        "actualCollection" : 576787,
        "expenditure" : 343434,
        "pendingExpendtiure" : 443545,
        "actualPayment" : 35435
      }
    ]
  };
}

