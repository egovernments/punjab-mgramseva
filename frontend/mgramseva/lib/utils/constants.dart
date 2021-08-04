import 'package:mgramseva/icons/home_icons_icons.dart';
import 'package:mgramseva/utils/models.dart';

class Constants {

  static const int PAGINATION_LIMIT = 75;

  static const String LOGIN_KEY = 'login_key';
  static const String LANGUAGE_KEY = 'language_key';
  static const String STATES_KEY = 'states_key';

  static List<KeyValue> GENDER = [
    KeyValue('Male', 'male'),
    KeyValue('Female', 'female'),
    KeyValue('Transgender', 'Transgender'),
  ];

  static List<KeyValue> EXPENSESTYPE = [
    KeyValue('YES', true),
    KeyValue('NO', false),
  ];
  static List<KeyValue> AMOUNTTYPE = [
    KeyValue('FULL', 'Full'),
    KeyValue('PARTIAL', 'Partial'),
  ];

  static const List<HomeItem> HOME_ITEMS = [
    HomeItem("CORE_HOUSEHOLD_REGISTER", HomeIcons.hhregister, ''),
    HomeItem("CORE_COLLECT_PAYMENTS", HomeIcons.collectpayment, 'household/search'),
    HomeItem("DOWNLOAD_BILLS_AND_RECEIPTS", HomeIcons.printreciept, ''),
    HomeItem("ADD_EXPENSES_RECORD", HomeIcons.addexpenses, 'expenses/add'),
    HomeItem("CORE_UPDATE_EXPENSES", HomeIcons.updateexpenses, ''),
    HomeItem("CORE_GENERATE_DEMAND", HomeIcons.generaedemand, 'bill/generate'),
    HomeItem("CORE_CONSUMER_CREATE", HomeIcons.createconsumer, 'consumer/create'),
    HomeItem("CORE_UPDATE_CONSUMER_DETAILS", HomeIcons.updateconsumer, 'consumer/search'),
    HomeItem("CORE_GPWSC_DASHBOARD", HomeIcons.dashboard, 'dashboard'),
  ];

  static List<KeyValue> SERVICECATEGORY = [
    KeyValue("Billing Service", "BILLING SERVICE"),
    KeyValue("Property Service", "PROPERTY SERVICE"),
    KeyValue("Rental Service", "RENTAL SERVICE"),
  ];

  static List<KeyValue> PROPERTYTYPE = [
    KeyValue("Residential", "RESIDENTIAL"),
    KeyValue("Non Residential", "NON RESIDENTIAL"),
  ];
  static List<KeyValue> SERVICETYPE = [
    KeyValue("Meter Connection", "METER CONNECTION"),
    KeyValue("Non Meter Connection", "NON METER CONNECTION"),
  ];
  static List<KeyValue> BILLINGYEAR = [
    KeyValue("2020-2021", "2020-2021"),
    KeyValue("2021-2022", "2021-2022"),
  ];

  static List<KeyValue> BILLINGCYCLE = [
    KeyValue("Sept-Oct", "SEPT-OCT"),
    KeyValue("Mar-Apr", "MAR-APR"),
    KeyValue("July-Aug", "JULY-AUG"),
  ];
}
