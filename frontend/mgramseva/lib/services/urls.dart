class Url {
  static UserUrl user = UserUrl();

  static const String LOCALIZATION = 'localization/messages/v1/_search';

  static const String MDMS = 'egov-mdms-service/v1/_search';

  /// Expenses
  static const String ADD_EXPENSES = 'echallan-services/eChallan/v1/_create';
  static const String EXPENSE_SEARCH = 'echallan-services/eChallan/v1/_search';

  // Proprety Create
  static const String ADD_PROPERTY = 'property-services/property/_create';
  // Connection Create
  static const String ADD_WC_CONNECTION = 'ws-services/wc/_create';

  // Connection Fetch
  static const String FETCH_WC_CONNECTION = 'ws-services/wc/_search';
  static const String VENDOR_SEARCH = 'vendor/v1/_search';
  static const String EGOV_LOCATIONS =
      'egov-location/location/v11/boundarys/_search';

  /// Connection bill payment
  static const String FETCH_BILL = 'billing-service/bill/v2/_fetchbill';
  static const String FETCH_DEMAND = 'billing-service/demand/_search';
}

class UserUrl {
  static const String RESET_PASSWORD = 'user/password/nologin/_update';
  static const String OTP_RESET_PASSWORD = 'user-otp/v1/_send';
  static const String AUTHENTICATE = 'user/oauth/token';
  static const String USER_PROFILE = 'user/_search';
  static const String EDIT_PROFILE = 'user/profile/_update';
  static const String CHANGE_PASSWORD = 'user/password/_update';
}
