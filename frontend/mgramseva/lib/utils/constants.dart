import 'package:mgramseva/icons/home_icons_icons.dart';
import 'package:mgramseva/utils/models.dart';

class Constants {

  static const String LOGIN_KEY = 'login_key';
  static const String LANGUAGE_KEY = 'language_key';
  static const String STATES_KEY = 'states_key';

  static List<KeyValue> GENDER = [
    KeyValue('Male', 'male'),
    KeyValue('Female', 'female'),
    KeyValue('Transgender', 'Transgender'),
  ];

  static List<KeyValue> EXPENSESTYPE = [
    KeyValue('YES', 'Yes'),
    KeyValue('NO', 'No'),
  ];
  static List<KeyValue> AMOUNTTYPE = [
    KeyValue('FULL', 'Full'),
    KeyValue('PARTIAL', 'Partial'),
  ];

  static const List<HomeItem> HOME_ITEMS = [
    HomeItem("Household Register", HomeIcons.hhregister, ''),
    HomeItem("Collect Payments", HomeIcons.collectpayment, 'household/search'),
    HomeItem("Download Bills & Receipts", HomeIcons.printreciept, ''),
    HomeItem("Add Expense Record", HomeIcons.addexpenses, 'expenses/add'),
    HomeItem("Update Expenses", HomeIcons.updateexpenses, ''),
    HomeItem("Generate Demand", HomeIcons.generaedemand, 'bill/generate'),
    HomeItem("CORE_CONSUMER_CREATE", HomeIcons.createconsumer, 'consumer/create'),
    HomeItem("Update Consumer Details", HomeIcons.updateconsumer, 'consumer/search'),
    HomeItem("GPWSC Dashboard", HomeIcons.dashboard, 'dashboard'),
  ];
}
