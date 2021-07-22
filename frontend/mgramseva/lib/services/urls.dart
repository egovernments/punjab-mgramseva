// ignore: non_constant_identifier_names
final Urls = {
  "localization": "localization/messages/v1/_search",
  "Authenticate": "user/oauth/token",
  "MDMS":"egov-mdms-service/v1/_search",
 "RESET_NEW_PASSWORD":"user/password/nologin/_update",
 "OTP_RESET_PASSWORD":"user-otp/v1/_send"
};


class Url {

  static UserUrl requestKeys = UserUrl();

  static const String LOCALIZATION = 'localization/messages/v1/_search' ;
  static const String AUTHENTICATE = 'user/oauth/token' ;
  static const String MDMS = 'egov-mdms-service/v1/_search' ;
  static const String RESET_PASSWORD = 'user/password/nologin/_update' ;
  static const String OTP_RESET_PASSWORD = 'user-otp/v1/_send' ;
}

class UserUrl {

}
