

import 'package:flutter/cupertino.dart';
import 'package:mgramseva/routers/Routers.dart';
import 'package:mgramseva/utils/custom_exception.dart';

import 'global_variables.dart';
import 'models.dart';

class ErrorHandler  {

  static void logError(String error, [StackTrace? stackTrace]){

  }

  static bool handleApiException(BuildContext context, CustomException e, [StackTrace? stackTrace]) {
    switch(e.exceptionType){
      case ExceptionType.UNAUTHORIZED:
        if(currentRoute == Routes.LOGIN){
          return true;
        }
        navigatorKey.currentState?.pushNamedAndRemoveUntil(Routes.LOGIN, (route) => false);
        return false;
      case ExceptionType.INVALIDINPUT: case ExceptionType.OTHER:case ExceptionType.FETCHDATA :case ExceptionType.BADREQUEST :
      logError(e.message ?? '', stackTrace);
       return true;
      case ExceptionType.CONNECTIONISSUE:
        return false;
      default :
        return true;
    }
  }
}