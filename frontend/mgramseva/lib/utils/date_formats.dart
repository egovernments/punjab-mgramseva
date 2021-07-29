import 'package:intl/intl.dart';

class DateFormats {

  static getFilteredDate(String date, {String? dateFormat}) {
    if (date == null || date.trim().isEmpty) return '';
    try {
      var dateTime = DateTime.parse(date).toLocal();
      return DateFormat(dateFormat ?? "dd-MM-yyyy").format(dateTime);
    } on Exception catch (e) {
      return '';
    }
  }

  static DateTime? getDateFromString(String date) {
    if (date == null || date.trim().isEmpty) return null;
    try {
      var dateTime = DateTime.parse(date).toLocal();
      return dateTime ?? null;
    } on Exception catch (e) {
      return null;
    }
  }

  static DateTime? getFormattedDateToDateTime(String date) {

    try {
      DateFormat inputFormat;
      if(date.contains('-')){
        inputFormat = DateFormat('dd-MM-yyyy');
      }else{
        inputFormat = DateFormat('dd/MM/yyyy');
      }
      var inputDate = inputFormat.parse(date);
      return inputDate;
    } on Exception catch (e) {
      return null;
    }
  }

  static String getTime(String date){
    if(date == null || date.trim().isEmpty) return '';
    try{
      var dateTime = getDateFromString(date);
      return DateFormat.Hms().format(dateTime!);
    } on Exception catch(e, stackTrace){
      return '';
    }
  }

  static String getLocalTime(String date){
    try{
      var dateTime = getDateFromString(date);
      return DateFormat.jm().format(dateTime!);
    } on Exception catch(e, stackTrace){
      return '';
    }
  }

  static int dateToTimeStamp(DateTime dateTime) {
   return dateTime.toUtc().millisecondsSinceEpoch;
  }

  static String timeStampToDate(int timeInMillis, {String? format}) {
    try {
      var date = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
      return DateFormat(format ?? 'dd-MM-yyyy').format(date);
    }catch(e){
      return '';
    }
  }

}
