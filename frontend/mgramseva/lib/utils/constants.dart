import 'package:mgramseva/utils/models.dart';

class Constants {

  static const String LOGIN_KEY = 'login_key';

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
}
