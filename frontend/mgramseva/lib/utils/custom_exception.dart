
import 'package:mgramseva/utils/models.dart';

class CustomException implements Exception {
  final String message;
  final int statusCode;
  final ExceptionType exceptionType;

  CustomException(this.message, this.statusCode, this.exceptionType);

  String toString() {
    return "$message";
  }
}