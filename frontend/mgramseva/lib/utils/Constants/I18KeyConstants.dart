class i18 {
  static Login login = const Login();
  static Common common = const Common();
  static Password password = const Password();
  static Expense expense = const Expense();
  static CreateConsumer consumer = const CreateConsumer();
  static SearchConnection searchConnection = const SearchConnection();
}

class Login {
  const Login();
  String get LOGIN_LABEL => 'CORE_COMMON_LOGIN';
  String get LOGIN_NAME => 'CORE_LOGIN_USERNAME';
  String get LOGIN_PASSWORD => 'CORE_LOGIN_PASSWORD';
  String get FORGOT_PASSWORD => 'CORE_COMMON_FORGOT_PASSWORD';
}

class Common {
  const Common();
  String get CONTINUE => 'CORE_COMMON_CONTINUE';
  String get NAME => 'CORE_COMMON_NAME';
  String get PHONE_NUMBER => 'CORE_COMMON_PHONE_NUMBER';
  String get MOBILE_NUMBER => 'CORE_COMMON_MOBILE_NUMBER';
  String get LOGOUT => 'CORE_COMMON_LOGOUT';
  String get EMAIL => 'CORE_COMMON_EMAIL';
  String get SAVE => 'CORE_COMMON_SAVE';
  String get SUBMIT => 'CORE_COMMON_BUTTON_SUBMIT';
  String get GENDER => 'CORE_COMMON_GENDER';
  String get MALE => 'CORE_COMMON_GENDER_MALE';
  String get FEMALE => 'CORE_COMMON_GENDER_FEMALE';
  String get TRANSGENDER => 'CORE_COMMON_GENDER_TRANSGENDER';

}

class Password{
  const Password();
  String get CHANGE_PASSWORD => 'CORE_COMMON_CHANGE_PASSWORD';
  String get CURRENT_PASSWORD => 'CORE_CHANGEPASSWORD_EXISTINGPASSWORD';
  String get NEW_PASSWORD => 'CORE_LOGIN_NEW_PASSWORD';
  String get CONFIRM_PASSWORD => 'CORE_LOGIN_CONFIRM_NEW_PASSWORD';
}

class Expense{
  const Expense();
  String get VENDOR_NAME => 'CORE_EXPENSE_VENDOR_NAME';
  String get EXPENSE_TYPE => 'CORE_EXPENSE_TYPE_OF_EXPENSES';
  String get AMOUNT => 'CORE_EXPENSE_AMOUNT';
  String get BILL_ISSUED_DATE => 'CORE_EXPENSE_BILL_ISSUED_DATE';
  String get BILL_PAID => 'CORE_EXPENSE_BILL_PAID';
  String get AMOUNT_PAID => 'CORE_EXPENSE_AMOUNT_PAID';
  String get ATTACH_BILL => 'CORE_EXPENSE_ATTACH_BILL';
}

class CreateConsumer{
  const CreateConsumer();
  String get CONSUMER_NAME => 'CREATE_CONSUMER_NAME';
  String get FATHER_SPOUSE_NAME => 'CONSUMER_FATHER_SPOUSE_NAME';
  String get OLD_CONNECTION_ID => 'CONSUMER_OLD_CONNECTION_ID';
  String get DOOR_NO => 'CONSUMER_DOOR_NO';
  String get STREET_NUM_NAME => 'CONSUMER_STREETNUM_STREETNAME';
  String get WARD => 'CONSUMER_WARD_LABEL';
  String get GP_NAME => 'CONSUMER_GP_NAME';
  String get Arrears => 'CONSUMER_ARREARS';
}

class SearchConnection{
  const SearchConnection();
  String get OWNER_MOB_NUM => 'SEARCH_CONNECTION_OWNER_MOB_NUM';
  String get CONSUMER_NAME => 'SEARCH_CONNECTION_NAME_OF_CONSUMER';
  String get OLD_CONNECTION_ID => 'SEARCH_CONNECTION_OLD_CONNECTION_ID';
  String get NEW_CONNECTION_ID => 'SEARCH_CONNECTION_NEW_CONNECTION_ID';
  String get SEARCH_BAR => 'SEARCH_CONNECTION_SEARCH';

}