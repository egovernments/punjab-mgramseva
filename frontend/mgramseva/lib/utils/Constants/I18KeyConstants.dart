class i18 {
  static Login login = const Login();
  static Common common = const Common();
  static Password password = const Password();
  static _Validators validators = const _Validators();

  static Expense expense = const Expense();
  static CreateConsumer consumer = const CreateConsumer();
  static SearchConnection searchConnection = const SearchConnection();
  static ProfileEdit profileEdit = const ProfileEdit();
  static DemandGenerate demandGenerate = const DemandGenerate();

}

class Login {
  const Login();
  String get LOGIN_LABEL => 'CORE_COMMON_LOGIN';
  String get LOGIN_NAME => 'CORE_LOGIN_USERNAME';
  String get LOGIN_PHONE_NO => 'LOGIN_PHONE_NO';
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
  String get BACK_HOME => 'CORE_COMMON_BACK_HOME_BUTTON';
  String get MGRAM_SEVA => 'CORE_COMMON_MGRAM_SEVA_LABEL';
  String get HOME => 'CORE_COMMON_HOME';
  String get EDIT_PROFILE => 'CORE_COMMON_EDIT_PROFILE';
  String get LANGUAGE => 'CORE_COMMON_LANGUAGE';

  /// File Picker
  String get TEMPORARY_FILES_REMOVED => 'TEMPORARY_FILES_REMOVED';

  ///Temporary files removed with success.
  String get FALIED_TO_FETCH_TEMPORARY_FILES =>
      'FALIED_TO_FETCH_TEMPORARY_FILES';

  /// Failed to clean temporary files
  String get ATTACH_BILL => 'ATTACH_BILL';

  /// Attach Bill
  String get CHOOSE_FILE => 'CHOOSE_FILE';

  /// Choose File
  String get NO_FILE_UPLOADED => 'NO_FILE_UPLOADED';

  /// No File Uploaded

}

class Password {
  const Password();
  String get CHANGE_PASSWORD => 'CORE_COMMON_CHANGE_PASSWORD';
  String get CURRENT_PASSWORD => 'CORE_CHANGEPASSWORD_EXISTINGPASSWORD';
  String get NEW_PASSWORD => 'CORE_LOGIN_NEW_PASSWORD';
  String get CONFIRM_PASSWORD => 'CORE_LOGIN_CONFIRM_NEW_PASSWORD';
  String get CHANGE_PASSWORD_SUCCESS => 'CHANGE_PASSWORD_SUCCESS_LABEL';
  String get CHANGE_PASSWORD_SUCCESS_SUBTEXT =>
      'CHANGE_PASSWORD_SUCCESS_SUB_TEXT';
}

class Expense {
  const Expense();
  String get VENDOR_NAME => 'CORE_EXPENSE_VENDOR_NAME';
  String get EXPENSE_TYPE => 'CORE_EXPENSE_TYPE_OF_EXPENSES';
  String get AMOUNT => 'CORE_EXPENSE_AMOUNT';
  String get BILL_DATE => 'CORE_EXPENSE_BILL_DATE';
  String get BILL_ISSUED_DATE => 'CORE_EXPENSE_BILL_ISSUED_DATE';
  String get PARTY_BILL_DATE => 'CORE_EXPENSE_PART_BILL_DATE';
  String get BILL_PAID => 'CORE_EXPENSE_BILL_PAID';
  String get AMOUNT_PAID => 'CORE_EXPENSE_AMOUNT_PAID';
  String get ATTACH_BILL => 'CORE_EXPENSE_ATTACH_BILL';
  String get EXPENDITURE_SUCESS => 'CORE_EXPENSE_EXPENDITURE_SUCESS';
  String get EXPENDITURE_AGAINST => 'CORE_EXPENSE_EXPENDITURE_AGAINST';
  String get UNDER_MAINTAINANCE => 'CORE_EXPENSE_UNDER_MAINTAINANCE';
  String get UNABLE_TO_CREATE_EXPENSE => 'CORE_EXPENSE_UNABLE_TO_EXPENSE';
  String get PAYMENT_DATE => 'CORE_EXPENSE_PAYMENT_DATE';
  String get EXPENSE_DETAILS => 'CORE_EXPENSE_EXPENSE_DETAILS';
  String get PROVIDE_INFO_TO_CREATE_EXPENSE =>
      'CORE_EXPENSE_PROVIDE_INFO_TO_CREATE_EXPENSE';
  String get ADD_EXPENSES_RECORD => 'ADD_EXPENSES_RECORD';

  /// Add Expense Record
}

class CreateConsumer {
  const CreateConsumer();
  String get CONSUMER_NAME => 'CREATE_CONSUMER_NAME';
  String get FATHER_SPOUSE_NAME => 'CONSUMER_FATHER_SPOUSE_NAME';
  String get OLD_CONNECTION_ID => 'CONSUMER_OLD_CONNECTION_ID';
  String get DOOR_NO => 'CONSUMER_DOOR_NO';
  String get STREET_NUM_NAME => 'CONSUMER_STREETNUM_STREETNAME';
  String get WARD => 'CONSUMER_WARD_LABEL';
  String get PROPERTY_TYPE => 'CONSUMER_PROPERTY_TYPE';
  String get CONSUMER_DETAILS_LABEL => 'CONSUMER_DETAILS_LABEL';
  String get CONSUMER_DETAILS_SUB_LABEL => 'CONSUMER_DETAILS_SUB_LABEL';
  String get GP_NAME => 'CONSUMER_GP_NAME';
  String get ARREARS => 'CONSUMER_ARREARS';
  String get SERVICE_TYPE => 'CONSUMER_SERVICE_TYPE';
  String get PREV_METER_READING_DATE => 'CONSUMER_PREV_METER_READING_DATE';
  String get METER_NUMBER => 'CONSUMER_METER_NUMBER';
  String get REGISTER_SUCCESS => 'CONSUMER_REGISTER_SUCCESS_LABEL';
}

class SearchConnection {
  const SearchConnection();
  String get OWNER_MOB_NUM => 'SEARCH_CONNECTION_OWNER_MOB_NUM';
  String get CONSUMER_NAME => 'SEARCH_CONNECTION_NAME_OF_CONSUMER';
  String get OLD_CONNECTION_ID => 'SEARCH_CONNECTION_OLD_CONNECTION_ID';
  String get NEW_CONNECTION_ID => 'SEARCH_CONNECTION_NEW_CONNECTION_ID';
  String get SEARCH_BAR => 'SEARCH_CONNECTION_SEARCH';
}

class ProfileEdit {
  const ProfileEdit();
  String get PROFILE_EDIT_SUCCESS => 'EDIT_PROFILE_SUCCESS_LABEL';
  String get PROFILE_EDITED_SUCCESS_SUBTEXT => 'EDIT_PROFILE_SUCCESS_SUB_TEXT';
}

class _Validators {
  const _Validators();

  /// Mobile number validations
  String get ENTER_MOBILE_NUMBER =>
      'ENTER_MOBILE_NUMBER'; //Please enter Mobile number
  String get ENTER_NUMBERS_ONLY =>
      'ENTER_NUMBERS_ONLY'; //Please enter Numbers only
  String get MOBILE_NUMBER_SHOULD_BE_10_DIGIT =>
      'MOBILE_NUMBER_SHOULD_BE_10_DIGIT'; //Mobile number should be 10 digits

  /// Re confirm password
  String get INVALID_FORMAT => 'INVALID_FORMAT'; // Invalid format
  String get CONFIRM_RECONFIRM_SHOULD_SAME =>
      'CONFIRM_RECONFIRM_SHOULD_SAME'; //New Password and Confirm password should be same

}

class DemandGenerate{
  const DemandGenerate();
  String get GENERATE_BILL_HEADER => 'GENERATE_CONSUMER_BILL_HEADER';
  String get SERVICE_CATEGORY_LABEL => 'GENERATE_DEMAND_SERVICE_CATEGORY_LABEL';
  String get PROPERTY_TYPE_LABEL => 'GENERATE_DEMAND_PROPERTY_TYPE_LABEL';
  String get SERVICE_TYPE_LABEL => 'GENERATE_DEMAND_SERVICE_TYPE_LABEL';
  String get METER_NUMBER_LABEL => 'GENERATE_DEMAND_METER_NUMBER_LABEL';
  String get BILLING_YEAR_LABEL => 'GENERATE_DEMAND_BILLING_YEAR_LABEL';
  String get BILLING_CYCLE_LABEL => 'GENERATE_DEMAND_BILLING_CYCLE_LABEL';
  String get PREV_METER_READING_LABEL => 'GENERATE_DEMAND_PREV_METER_READING_LABEL';
  String get NEW_METER_READING_LABEL => 'GENERATE_DEMAND_NEW_METER_READING_LABEL';
  String get GENERATE_BILL_BUTTON => 'GENERATE_DEMAND_GEN_BILL_BUTTON';
  String get GENERATE_BILL_SUCCESS => 'BILL_GENERATED_SUCCESSFULLY_LABEL';
  String get GENERATE_BILL_SUCCESS_SUBTEXT => 'BILL_GENERATED_SUCCESS_SUBTEXT';
}

