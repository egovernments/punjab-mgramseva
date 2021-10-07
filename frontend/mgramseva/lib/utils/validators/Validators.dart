import 'package:mgramseva/utils/Constants/I18KeyConstants.dart';
import 'package:mgramseva/utils/Locilization/application_localizations.dart';
import 'package:mgramseva/utils/global_variables.dart';

class Validators {
  static validate(value, type) {
    if (type == 'Email') {
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      return (regex.hasMatch(value)) ? null : 'Enter a valid Email';
    } else if (type == 'Mobile Number') {
      String pattern = r'^([0|\+[0-9]{1,5})?([7-9][0-9]{9})$';
      RegExp regex = new RegExp(pattern);
      return (regex.hasMatch(value)) ? null : 'Enter a valid mobile Number';
    } else if (type == 'OTP') {
      String pattern = r'^[0-9]+$';
      RegExp regex = new RegExp(pattern);
      return (regex.hasMatch(value))
          ? (value.length < 4)
              ? 'Enter a valid OTP'
              : null
          : 'Enter a valid OTP';
    } else if (type == 'Flat Id') {
      return (value.length < 3) ? 'Enter a valid Flat Id' : null;
    } else if (type == 'CORE_LOGIN_USERNAMEs') {
      String pattern = r'^[A-Za-z ]+$';
      RegExp regex = new RegExp(pattern);
      return (regex.hasMatch(value))
          ? (value.length < 3)
              ? 'Enter a valid Name'
              : null
          : 'Enter a valid Name';
    } else if (type == 'Password') {
      return (value.length < 8) ? 'Please provide  8 characters' : null;
    } else if (type == 'Old Password' ||
        type == 'New Password' ||
        type == 'Confirm Password')
      return (value.length < 8) ? 'Please provide  8 characters' : null;
  }

  static String? mobileNumberValidator(String? v) {
    if (v!.trim().isEmpty) {
      return '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.validators.ENTER_MOBILE_NUMBER)}';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(v)) {
      return '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.validators.ENTER_NUMBERS_ONLY)}';
    } else if (v.trim().length != 10) {
      return '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.validators.MOBILE_NUMBER_SHOULD_BE_10_DIGIT)}';
    }
    return null;
  }

  static String? passwordComparision(String? val, String label,
      [String? val1]) {
    if (val!.trim().isEmpty) {
      return '$label';
    } else if (!(RegExp(
            r'^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,}$')
        .hasMatch(val))) {
      return '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.validators.INVALID_FORMAT)}';
    } else if (val1 != null && val.trim() != val1.trim()) {
      return '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.validators.CONFIRM_RECONFIRM_SHOULD_SAME)}';
    }
    return null;
  }

  static String? meterNumberValidator(String? v) {
    if (v!.trim().isEmpty) {
      return '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.validators.ENTER_METER_NUMBER)}';
    } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(v)) {
      return '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.validators.ENTER_ALPHA_NUMERIC_ONLY)}';
    }
    return null;
  }

  static String? amountValidator(String? v) {
    if (v!.trim().isEmpty) {
      return '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.expense.AMOUNT_MENTIONED_IN_THE_BILL)}';
    } else if (double.parse(v) <= 0) {
      return '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.expense.ENTER_VALID_AMOUNT)}';
    }
    return null;
  }

  static String? rangeValidatior(String? v, double? inputnum) {
    if (v!.trim().isEmpty) {
      return '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.validators.ENTER_METER_NUMBER)}';
    } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(v)) {
      return '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.validators.ENTER_ALPHA_NUMERIC_ONLY)}';
    } else if (double.parse(v) > (inputnum!)) {
      return '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.validators.PARTIAL_AMT_OUT_OF_RANGE)}';
    }
    return null;
  }

  static String? partialAmountValidatior(String? v, double? inputnum) {
    if (v!.trim().isEmpty) {
      return '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.validators.CANNOT_BE_EMPTY)}';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(v)) {
      return '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.validators.ENTER_NUMBERS_ONLY)}';
    } else if (double.parse(v) > (inputnum!)) {
      return '${ApplicationLocalizations.of(navigatorKey.currentContext!).translate(i18.validators.AMOUNT_EXCEEDS)}';
    }
    return null;
  }
}
