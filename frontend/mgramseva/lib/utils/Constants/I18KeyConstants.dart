class i18 {
  static Login login = const Login();
  static Common common = const Common();
  static Password password = const Password();
  static _Validators validators = const _Validators();
  static ConsumerReciepts consumerReciepts = const ConsumerReciepts();
  static Expense expense = const Expense();
  static CreateConsumer consumer = const CreateConsumer();
  static SearchWaterConnection searchWaterConnection =
      const SearchWaterConnection();
  static ProfileEdit profileEdit = const ProfileEdit();
  static BillDetails billDetails = const BillDetails();
  static GenerateBillDetails generateBillDetails = const GenerateBillDetails();
  static DemandGenerate demandGenerate = const DemandGenerate();
  static _NetWorkException netWorkException = const _NetWorkException();
  static _Payment payment = const _Payment();
  static _HomeWalkThroughMsg homeWalkThroughMSg = const _HomeWalkThroughMsg();
  static _ConsumerWalkThroughMsg consumerWalkThroughMsg = const _ConsumerWalkThroughMsg();
  static _ExpenseWalkThroughMsg expenseWalkThroughMsg = const _ExpenseWalkThroughMsg();
}

class Login {
  const Login();
  String get LOGIN_LABEL => 'CORE_COMMON_LOGIN';
  String get LOGIN_NAME => 'CORE_LOGIN_USERNAME';
  String get LOGIN_PHONE_NO => 'LOGIN_PHONE_NO';
  String get LOGIN_PASSWORD => 'CORE_LOGIN_PASSWORD';
  String get FORGOT_PASSWORD => 'CORE_COMMON_FORGOT_PASSWORD';
  String get INVALID_CREDENTIALS => 'INVALID_CREDENTIALS';
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
  String get PROFILE_PASSWORD_SUCCESS_LABEL => 'PROFILE_PASSWORD_SUCCESS_LABEL';
  String get RESET_PASSWORD => 'CORE_COMMON_RESET_PASSWORD';
  String get ENTER_OTP_SENT => 'CORE_COMMON_ENTER_OTP_SENT';
  String get RESEND_OTP => 'CORE_COMMON_RESEND_OTP';

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

  String get ELECTRICITY_HINT => 'ELECTRICITY_HINT';

  /// Eg: Electricity
  String get BILL_HINT => 'BILL_HINT';

  /// Eg: EB-2021-22-0052
  String get SHOW_MORE => 'SHOW_MORE';

  /// Show more
  String get SHOW_LESS => 'SHOW_LESS';

  /// Show Less
  String get BILL_ID => 'BILL_ID';

  /// Bill ID
  String get OR => 'OR';

  /// Or
  String get SEARCH => 'SEARCH';

  /// Search
  String get AMOUNT => 'AMOUNT';

  /// Amount
  String get STATUS => 'STATUS';

  /// Status
  String get CONSUMERS_FOUND => 'CONSUMERS_FOUND';

  /// consumer(s) Found
  String get EXPENSES_FOUND => 'EXPENSES_FOUND';

  String get CONNECTION_ID => 'CONNECTION_ID'; //Connection ID
  String get CONSUMER_NAME => 'CONSUMER_NAME'; //Consumer Name
  String get TOTAL_DUE_AMOUNT => 'TOTAL_DUE_AMOUNT'; //Total Amount Due
  String get PAYMENT_AMOUNT => 'PAYMENT_AMOUNT'; //Payment Amount
  String get PAYMENT_METHOD => 'PAYMENT_METHOD'; //Payment Method
  String get PAYMENT_INFORMATION => 'PAYMENT_INFORMATION'; //Payment Information
  String get WATER_CHARGES => 'WATER_CHARGES'; //Please enter Mobile number
  String get ARREARS => 'ARREARS'; //Please enter Mobile number
  String get COLLECT_PAYMENT => 'COLLECT_PAYMENT';
  String get ONLINE => 'ONLINE';
  String get CHEQUE => 'CHEQUE';
  String get CASH => 'CASH';
  String get FULL_AMOUNT => 'FULL_AMOUNT';
  String get CUSTOM_AMOUNT => 'CUSTOM_AMOUNT';

  String get PAYMENT_COMPLETE => 'PAYMENT_COMPLETE'; /// Payment complete
  String get RECEIPT_NO => 'RECEIPT_NO'; /// Payment complete
  String get DOWNLOAD => 'DOWNLOAD'; /// Payment complete
  String get SHARE_BILL => 'SHARE_BILL'; /// Payment complete
  String get ATTACHMENTS => 'ATTACHMENTS';
  String get YES => 'YES';
  String get NO => 'NO';

  String get SKIP => 'SKIP';
  String get NEXT => 'NEXT';


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
  String get PASSWORD_HINT => 'CORE_CHANGEPASSWORD_PASSWORD_HINT';
  String get PASS_HINT_MIN_SIX_DIGITS => 'CORE_PASS_HINT_MIN_SIX_DIGITS';
  String get PASS_HINT_ATLEAST_ONE_LETTER =>
      'CORE_PASS_HINT_ATLEAST_ONE_LETTER';
  String get PASS_HINT_ATLEAST_ONE_NUMBER =>
      'CORE_PASS_HINT_ATLEAST_ONE_NUMBER';
  String get PASS_HINT_ATLEAST_ONE_SPECIAL_CHARACTER =>
      'CORE_PASS_HINT_ATLEAST_ONE_SPECIAL_CHARACTER';
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
  String get PAYMENT_DATE => 'CORE_EXPENSE_PAYMENT_DATE';
  String get EXPENSE_DETAILS => 'CORE_EXPENSE_EXPENSE_DETAILS';
  String get PROVIDE_INFO_TO_CREATE_EXPENSE =>
      'CORE_EXPENSE_PROVIDE_INFO_TO_CREATE_EXPENSE';
  String get ADD_EXPENSES_RECORD => 'ADD_EXPENSES_RECORD';
  String get NO_EXPENSE_RECORD_FOUND => 'NO_EXPENSE_RECORD_FOUND';

  /// No Record were Found with this Challan No
  String get SEARCH_EXPENSE_BILL => 'SEARCH_EXPENSE_BILL';

  /// Search Expense Bills
  String get ENTER_VENDOR_BILL_EXPENSE => 'ENTER_VENDOR_BILL_EXPENSE';

  /// Enter the Vendor Name or Expenditure type or Bill ID to get more details. Please enter only one
  String get UPDATE_EXPENDITURE => 'UPDATE_EXPENDITURE';

  /// Update Expenditure
  String get FOLLOWING_EXPENDITURE_BILL_MATCH =>
      'FOLLOWING_EXPENDITURE_BILL_MATCH';

  /// Following expenditure bills match search critera
  String get NO_EXPENSES_FOUND => 'NO_EXPENSES_FOUND';

  /// No Expenses found
  String get UNABLE_TO_SEARCH_EXPENSE => 'UNABLE_TO_SEARCH_EXPENSE';

  /// Unable to Search the Expenses
  String get NO_FIELDS_FILLED => 'NO_FIELDS_FILLED';

  ///Modified expenditure successfully
  String get MODIFIED_EXPENDITURE_SUCCESSFULLY => 'MODIFIED_EXPENDITURE_SUCCESSFULLY';

  ///Expenditure Bill with id
  String get EXPENDITURE_BILL_ID => 'EXPENDITURE_BILL_ID';

  ///Has been modified
  String get HAS_BEEN_MODIFIED => 'HAS_BEEN_MODIFIED';
  String get ENTER_VALID_AMOUNT => 'ENTER_VALID_AMOUNT';
  String get BILL_DATE_CANNOT_BEFORE_PART_DATE => 'ENTER_VALID_AMOUNT';
  String get BILL_DATE_CANNOT_GREATER_THAN_TODAY => 'ENTER_VALID_AMOUNT';
  String get PARTY_BILL_DATE_CANNOT_GREATER_THAN_TODAY => 'ENTER_VALID_AMOUNT';
  String get PAYMENT_DATE_CANNOT_GREATER_THAN_TODAY => 'ENTER_VALID_AMOUNT';
  String get PAYMENT_DATE_CANNOT_BEFORE_PARTY_DATE => 'ENTER_VALID_AMOUNT';
  String get UN_PAID => 'UN_PAID';
  String get PAID => 'PAID';
  String get EDIT_EXPENSE_BILL => 'EDIT_EXPENSE_BILL';
  String get UPDATE_SUBMIT_EXPENDITURE => 'UPDATE_SUBMIT_EXPENDITURE';
  String get MARK_BILL_HAS_CANCELLED => 'MARK_BILL_HAS_CANCELLED';

  ///Required messages for expenses
  String get SELECT_EXPENDITURE_CATEGORY => 'SELECT_EXPENDITURE_CATEGORY';
  String get MENTION_NAME_OF_VENDOR => 'MENTION_NAME_OF_VENDOR';
  String get AMOUNT_MENTIONED_IN_THE_BILL => 'AMOUNT_MENTIONED_IN_THE_BILL';
  String get DATE_BILL_ENTERED_IN_RECORDS => 'DATE_BILL_ENTERED_IN_RECORDS';
  String get DATE_ON_WHICH_BILL_RAISED => 'DATE_ON_WHICH_BILL_RAISED';
  String get ATTACH_FORMATS => 'ATTACH_FORMATS';
  String get CORE_EXPENSE_EXPENDITURE_SUCESS => 'CORE_EXPENSE_EXPENDITURE_SUCESS';
  String get HAS_THIS_BILL_PAID => 'HAS_THIS_BILL_PAID';
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
  String get CONSUMER_EDIT_DETAILS_LABEL => 'CONSUMER_EDIT_DETAILS_LABEL';
  String get CONSUMER_EDIT_DETAILS_SUB_LABEL =>
      'CONSUMER_DETAILS_EDIT_SUB_LABEL';
  String get GP_NAME => 'CONSUMER_GP_NAME';
  String get ARREARS => 'CONSUMER_ARREARS';
  String get CONSUMER_CONNECTION_ID => 'CONSUMER_CONNECTION_ID';
  String get SERVICE_TYPE => 'CONSUMER_SERVICE_TYPE';
  String get PREV_METER_READING_DATE => 'CONSUMER_PREV_METER_READING_DATE';
  String get METER_NUMBER => 'CONSUMER_METER_NUMBER';
  String get REGISTER_SUCCESS => 'CONSUMER_REGISTER_SUCCESS_LABEL';
  String get CONSUMER_BILLING_CYCLE => 'CONSUMER_BILLING_CYCLE';
}

class SearchWaterConnection {
  const SearchWaterConnection();
  String get OWNER_MOB_NUM => 'SEARCH_CONNECTION_OWNER_MOB_NUM';
  String get CONSUMER_NAME => 'SEARCH_CONNECTION_NAME_OF_CONSUMER';
  String get OLD_CONNECTION_ID => 'SEARCH_CONNECTION_OLD_CONNECTION_ID';
  String get NEW_CONNECTION_ID => 'SEARCH_CONNECTION_NEW_CONNECTION_ID';
  String get SEARCH_CONNECTION_LABEL => 'SEARCH_CONNECTION_LABEL';
  String get SEARCH_CONNECTION_BUTTON => 'SEARCH';
  String get SEARCH_CONNECTION_SUBLABEL => 'SEARCH_CONNECTION_SUBLABEL';
  String get HOUSE_DETAILS_VIEW => 'HOUSE_DETAILS_VIEW';
  String get HOUSE_DETAILS_EDIT => 'HOUSE_DETAILS_EDIT';
  String get HOUSE_ADDRESS => 'HOUSE_ADDRESS';
  String get CONNECTION_TYPE => 'CONNECTION_TYPE';
  String get PROPERTY_TYPE => 'PROPERTY_TYPE';
  String get CONNECTION_FOUND => 'CONNECTION_FOUND';
  String get CONNECTION_CRITERIA => 'CONNECTION_CRITERIA';
  String get NO_CONNECTION_FOUND => 'NO_CONNECTION_FOUND';
  String get NAME_HINT => 'NAME_OF_CONSUMER_HINT';
  String get OLD_CONNECTION_HINT => 'OLD_CONNECTION_HINT';
  String get NEW_CONNECTION_HINT => 'NEW_CONNECTION_HINT';
  String get RESULTS_CONSUMER_NAME => 'SEARCH_CONNECTION_CONSUMER_NAME';
  String get RESULTS_PHONE_NUM => 'SEARCH_CONNECTION_PHONE_NUMBER';
  String get RESULTS_ADDRESS => 'SEARCH_CONNECTION_ADDRESS';

}

class ProfileEdit {
  const ProfileEdit();
  String get PROFILE_EDIT_SUCCESS => 'EDIT_PROFILE_SUCCESS_LABEL';
  String get PROFILE_EDITED_SUCCESS_SUBTEXT => 'EDIT_PROFILE_SUCCESS_SUB_TEXT';
  String get PROFILE_EDIT_EMAIL_HINT => 'EMAIL_HINT';
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

class DemandGenerate {
  const DemandGenerate();
  String get GENERATE_BILL_HEADER => 'GENERATE_CONSUMER_BILL_HEADER';
  String get SERVICE_CATEGORY_LABEL => 'GENERATE_DEMAND_SERVICE_CATEGORY_LABEL';
  String get PROPERTY_TYPE_LABEL => 'GENERATE_DEMAND_PROPERTY_TYPE_LABEL';
  String get SERVICE_TYPE_LABEL => 'GENERATE_DEMAND_SERVICE_TYPE_LABEL';
  String get METER_NUMBER_LABEL => 'GENERATE_DEMAND_METER_NUMBER_LABEL';
  String get BILLING_YEAR_LABEL => 'GENERATE_DEMAND_BILLING_YEAR_LABEL';
  String get BILLING_CYCLE_LABEL => 'GENERATE_DEMAND_BILLING_CYCLE_LABEL';
  String get PREV_METER_READING_LABEL =>
      'GENERATE_DEMAND_PREV_METER_READING_LABEL';
  String get NEW_METER_READING_LABEL =>
      'GENERATE_DEMAND_NEW_METER_READING_LABEL';
  String get GENERATE_BILL_BUTTON => 'GENERATE_DEMAND_GEN_BILL_BUTTON';
  String get GENERATE_BILL_SUCCESS => 'BILL_GENERATED_SUCCESSFULLY_LABEL';
  String get GENERATE_BILL_SUCCESS_SUBTEXT => 'BILL_GENERATED_SUCCESS_SUBTEXT';
  String get OLD_METER_READING_INVALID =>
      'OLD_METER_READING_INVALID_MSG'; //Old Meter Reading is Invalid
  String get NEW_METER_READING_INVALID =>
      'NEW_METER_READING_INVALID_MSG'; //New Meter Reading is Invalid
  String get NEW_METER_READING_SHOULD_GREATER_THAN_OLD_METER_READING =>
      'NEW_METER_READING_SHOULD_GREATER_THAN_OLD_METER_READING'; //New Meter Reading should be greater than Old meter Reading
  String get METER_READING_DATE => 'GENERATE_DEMAND_METER_READING_DATE';
  String get GENERATE_DEMAND_SUCCESS => 'DEMAND_GENERATED_SUCCESSFULLY_LABEL';
  String get GENERATE_DEMAND_SUCCESS_SUBTEXT =>
      'DEMAND_GENERATED_SUCCESS_SUBTEXT';
}

class BillDetails {
  const BillDetails();
  String get NEW_CONSUMERGENERATE_BILL_LABEL =>
      'NEW_CONSUMER_GENERATE_BILL_LABEL';
  String get LAST_BILL_GENERATED_DATE => 'LAST_BILL_GENERATED_DATE';
  String get CURRENT_BILL => 'CURRENT_BILL';
  String get ARRERS_DUES => 'ARRERS_DUES';
  String get TOTAL_AMOUNT => 'TOTAL_AMOUNT';
  String get COLLECT_PAYMENT => 'COLLECT_PAYMENT';
}

class GenerateBillDetails {
  const GenerateBillDetails();
  String get GENERATE_BILL_LABEL => 'GENERATE_BILL_LABEL';
  String get LAST_BILL_GENERATION_DATE => 'LAST_BILL_GENERATION_DATE';
  String get PREVIOUS_METER_READING => 'PREVIOUS_METER_READING';
  String get PENDING_AMOUNT => 'PENDING_AMOUNT';
  String get DAYS_AGO => 'DAYS_AGO';
  String get GENERATE_NEW_BTN_LABEL => 'GENERATE_NEW_BTN_LABEL';
}

class ConsumerReciepts {
  const ConsumerReciepts();
  String get CONSUMER_BILL_RECIEPTS_LABEL => 'CONSUMER_BILL_RECIEPTS_LABEL';
  String get CONSUMER_BILL_RECIEPT_ID => 'CONSUMER_BILL_RECIEPT_ID';
  String get CONSUMER_RECIEPT_PAID_AMOUNT => 'CONSUMER_RECIEPT_PAID_AMOUNT';
  String get CONSUMER_RECIEPT_PAID_DATE => 'CONSUMER_RECIEPT_PAID_DATE';
  String get CONSUMER_RECIEPT_SHARE_RECEIPT => 'CONSUMER_RECIEPT_SHARE_RECEIPT';
}

class _NetWorkException {
  const _NetWorkException();

  String get CHECK_CONNECTION => 'CHECK_CONNECTION';
}

class _Payment {
  const _Payment();

  String get HIDE_DETAILS => 'HIDE_DETAILS'; //Hide Details
  String get VIEW_DETAILS => 'VIEW_DETAILS'; //View Details
  String get BILL_ID_NUMBER => 'BILL_ID_NUMBER'; //Bill ID No
  String get BILL_PERIOD => 'BILL_PERIOD'; //Bill Period
  String get FREE_ESTIMATE => 'FREE_ESTIMATE'; //Fee Estimate
  String get RECEIPT_REFERENCE_WITH_MOBILE_NUMBER =>
      'RECEIPT_REFERENCE_WITH_MOBILE_NUMBER'; //Fee Estimate

}

class _HomeWalkThroughMsg{
  const _HomeWalkThroughMsg();

  String get HOUSEHOLD_REGISTER_MSG => 'HOUSEHOLD_REGISTER_MSG';
  String get COLLECT_PAYMENTS_MSG => 'COLLECT_PAYMENTS_MSG';
  String get DOWNLOAD_BILLS_AND_RECEIPTS_MSG => 'DOWNLOAD_BILLS_AND_RECEIPTS_MSG';
  String get ADD_EXPENSE_RECORD_MSG => 'ADD_EXPENSE_RECORD_MSG';
  String get CREATE_CONSUMER_MSG => 'CREATE_CONSUMER_MSG';
  String get GPWSC_DASHBOARD_MSG => 'GPWSC_DASHBOARD_MSG';
}

class _ConsumerWalkThroughMsg{
  const _ConsumerWalkThroughMsg();

  String get CONSUMER_NAME_MSG => 'CONSUMER_NAME_MSG';
  String get CONSUMER_GENDER_MSG => 'CONSUMER_GENDER_MSG';
  String get CONSUMER_FATHER_MSG => 'CONSUMER_FATHER_MSG';
  String get CONSUMER_MOBILE_MSG => 'CONSUMER_MOBILE_MSG';
  String get CONSUMER_OLD_ID_MSG => 'CONSUMER_OLD_ID_MSG';
  String get CONSUMER_WARD_MSG => 'CONSUMER_WARD_MSG';
  String get CONSUMER_PROPERTY_TYPE_MSG => 'CONSUMER_PROPERTY_TYPE_MSG';
  String get CONSUMER_SERVICE_TYPE_MSG => 'CONSUMER_SERVICE_TYPE_MSG';
  String get CONSUMER_ARREARS_MSG => 'CONSUMER_ARREARS_MSG';
}

class _ExpenseWalkThroughMsg{
  const _ExpenseWalkThroughMsg();

  String get EXPENSE_TYPE_MSG => 'EXPENSE_TYPE_MSG';
  String get EXPENSE_VENDOR_NAME_MSG => 'EXPENSE_VENDOR_NAME_MSG';
  String get EXPENSE_AMOUNT_MSG => 'EXPENSE_AMOUNT_MSG';
  String get EXPENSE_BILL_DATE_MSG => 'EXPENSE_BILL_DATE_MSG';
  String get EXPENSE_PARTY_BILL_DATE_MSG => 'EXPENSE_PARTY_BILL_DATE_MSG';
  String get EXPENSE_ATTACH_BILL_MSG => 'EXPENSE_ATTACH_BILL_MSG';
}


