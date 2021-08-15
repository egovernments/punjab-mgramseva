class Url {
  static UserUrl user = UserUrl();

  static const String LOCALIZATION = 'localization/messages/v1/_search';

  static const String MDMS = 'egov-mdms-service/v1/_search';

  /// Expenses
  static const String ADD_EXPENSES = 'echallan-services/eChallan/v1/_create';
  static const String EXPENSE_SEARCH = 'echallan-services/eChallan/v1/_search';

  // Proprety Create
  static const String ADD_PROPERTY = 'property-services/property/_create';
  //Property Fetch
  static const String GET_PROPERTY = 'property-services/property/_search';
//Property  Update
  static const String UPDATE_PROPERTY = 'property-services/property/_update';
  // Connection Create
  static const String ADD_WC_CONNECTION = 'ws-services/wc/_create';

  // Connection Create
  static const String UPDATE_WC_CONNECTION = 'ws-services/wc/_update';

  //Demand Generation
  static const String METER_CONNECTION_DEMAND =
      'ws-calculator/meterConnection/_create';
  static const String BULK_DEMAND = 'ws-calculator/waterCalculator/_bulkDemand';
  static const String SEARCH_METER_CONNECTION_DEMAND =
      'ws-calculator/meterConnection/_search';

  ///Fetch Demands
  static const String FETCH_DEMAND = 'billing-service/demand/_search';

  static const String FETCH_BILL = 'billing-service/bill/v2/_fetchbill';
  // Connection Fetch
  static const String FETCH_WC_CONNECTION = 'ws-services/wc/_search';
  static const String VENDOR_SEARCH = 'vendor/v1/_search';
  static const String EGOV_LOCATIONS =
      'egov-location/location/v11/boundarys/_search';

  /// Connection bill payment
  static const String COLLECT_PAYMENT = 'collection-services/payments/_create';
}

class UserUrl {
  static const String RESET_PASSWORD = 'user/password/nologin/_update';
  static const String OTP_RESET_PASSWORD = 'user-otp/v1/_send';
  static const String AUTHENTICATE = 'user/oauth/token';
  static const String USER_PROFILE = 'user/_search';
  static const String EDIT_PROFILE = 'user/profile/_update';
  static const String CHANGE_PASSWORD = 'user/password/_update';
}
