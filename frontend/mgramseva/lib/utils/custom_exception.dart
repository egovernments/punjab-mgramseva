
import 'package:mgramseva/utils/models.dart';

class CustomException implements Exception {
  final String _message;
  final int statusCode;
  final ExceptionType exceptionType;

  CustomException(this._message, this.statusCode, this.exceptionType);

  String toString() {
    return "$_message";
  }
}