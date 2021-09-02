class Routes {
  ///Authentication
  static const String LANDING_PAGE = '/';

  static const String LOGIN = '/login';

  static const String SELECT_LANGUAGE = '/selectLanguage';

  static const String HOME = '/home';

  static const String FORGOT_PASSWORD = '/forgotPassword';

  // static const String HOUSE_HOLD = 'household/search';

  static const String HOUSEHOLD = '/home/householdSearch';
  static const String HOUSEHOLDRECEIPTS = '/home/householdReceiptsSearch';
  static const String HOUSEHOLD_REGISTER = '/home/householdRegister';

  static const String UPDATE_PASSWORD = 'updatepassword';

  static const String RESET_PASSWORD = '$FORGOT_PASSWORD/resetPassword';

  static const String CONSUMER_SEARCH = 'consumer/search';

  /// Profile
  static const String EDIT_PROFILE = '/home/editProfile';

  static const String CHANGE_PASSWORD = '/home/editProfile/changepassword';

  static const String CHANGE_PASSWORD_SUCCESS = '$CHANGE_PASSWORD/success';

  static const String EDIT_PROFILE_SUCCESS = '$EDIT_PROFILE/success';

  /// Expense
  static const String EXPENSES_ADD = '/home/addExpense';

  static const String EXPENSES_ADD_SUCCESS = '/home/addExpense/success';

  static const String EXPENSE_SEARCH = '/home/searchExpense';

  static const String EXPENSE_RESULT = '/home/searchExpense/result';

  static const String EXPENSE_UPDATE =
      '/home/searchExpense/result/updateExpense';

  static const String HOUSEHOLD_DETAILS = '/household/details';

  static const String HOUSEHOLD_DETAILS_COLLECT_PAYMENT =
      '/household/details/collectPayment';

  static const String HOUSEHOLD_DETAILS_SUCCESS =
      '$HOUSEHOLD_DETAILS_COLLECT_PAYMENT/success';

  static const String DASHBOARD = 'dashboard';

  static const String BILL_GENERATE = '/bill/generate';

  static const String MANUAL_BILL_GENERATE = 'bill/manual/generate';

  ///  Consumer
  static const String CONSUMER_CREATE = '/home/consumer/create';

  static const String CONSUMER_SEARCH_UPDATE = '/home/consumer/searchupdate';
  static const String CONSUMER_UPDATE = '/home/consumer/update';

  static const String SEARCH_CONSUMER_RESULT = '/home/consumer/search';

  static const String PAYMENT_SUCCESS = 'paymentSuccess';

  static const String SUCCESS_VIEW = '/success';

  static const String POST_PAYMENT_FEED_BACK = '/feedBack';
}
