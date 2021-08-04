import 'package:mgramseva/icons/home_icons_icons.dart';
import 'package:mgramseva/utils/models.dart';

class Constants {

  static const int PAGINATION_LIMIT = 75;

  static const String LOGIN_KEY = 'login_key';
  static const String LANGUAGE_KEY = 'language_key';
  static const String STATES_KEY = 'states_key';

  static List<KeyValue> GENDER = [
    KeyValue('Male', 'MALE'),
    KeyValue('Female', 'FEMALE'),
    KeyValue('Transgender', 'TRANSGENDER'),
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
    HomeItem("Household Register", HomeIcons.hhregister, ''),
    HomeItem("Collect Payments", HomeIcons.collectpayment, 'household/search'),
    HomeItem("Download Bills & Receipts", HomeIcons.printreciept, ''),
    HomeItem("ADD_EXPENSES_RECORD", HomeIcons.addexpenses, 'expenses/add'),
    HomeItem("Update Expenses", HomeIcons.updateexpenses, ''),
    HomeItem("Generate Demand", HomeIcons.generaedemand, 'bill/generate'),
    HomeItem("CORE_CONSUMER_CREATE", HomeIcons.createconsumer, 'consumer/create'),
    HomeItem("Update Consumer Details", HomeIcons.updateconsumer, 'consumer/search'),
    HomeItem("GPWSC Dashboard", HomeIcons.dashboard, 'dashboard'),
  ];
}
