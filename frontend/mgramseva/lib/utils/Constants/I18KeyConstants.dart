class i18 {
  static Login login = const Login();
  static Common common = const Common();
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
}
