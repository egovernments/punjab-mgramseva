class Url {
  static UserUrl user = UserUrl();

  static const String LOCALIZATION = 'localization/messages/v1/_search';

  static const String MDMS = 'egov-mdms-service/v1/_search';

  /// Expenses
  static const String ADD_EXPENSES = 'echallan-services/eChallan/v1/_create';
}

class UserUrl {
  static const String RESET_PASSWORD = 'user/password/nologin/_update';
  static const String OTP_RESET_PASSWORD = 'user-otp/v1/_send';
  static const String AUTHENTICATE = 'user/oauth/token';
  static const String USER_PROFILE = 'user/_search';
  static const String EDIT_PROFILE = 'user/profile/_update';
  static const String CHANGE_PASSWORD = 'user/password/update';
}
