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

  static getKyFilteredDate(String date) {
    if (date == null || date.trim().isEmpty) return '';

    try {
      DateFormat inputFormat;
      if(date.contains('-')){
        inputFormat = DateFormat('dd-MM-yyyy');
      }else{
        inputFormat = DateFormat('dd/MM/yyyy');
      }
      var inputDate = inputFormat.parse(date);
      return DateFormat("yyyy-MM-dd").format(inputDate);
    } on Exception catch (e) {
      return '';
    }
  }

  static getDoiFilteredDate(String date) {
    if (date == null || date.trim().isEmpty) return '';

    try {
      DateFormat inputFormat;
      inputFormat = DateFormat('dd-MM-yyyy');
      var inputDate = inputFormat.parse(date);
      return DateFormat("dd/MM/yyyy").format(inputDate);
    } on Exception catch (e) {
      return '';
    }
  }

  static getDateFromString(String date) {
    if (date == null || date.trim().isEmpty) return null;
    try {
      var dateTime = DateTime.parse(date).toLocal();
      return dateTime ?? null;
    } on Exception catch (e) {
      return null;
    }
  }

  static getDayNameWithMonth(String date){
    try{
      var dateTime = getDateFromString(date);
      return '${DateFormat('EEE d MMMM').format(dateTime)}';
    } on Exception catch(e, stackTrace){
      return '';
    }
  }

  static String getTime(String date){
    if(date == null || date.trim().isEmpty) return '';
    try{
      var dateTime = getDateFromString(date);
      return DateFormat.Hms().format(dateTime);
    } on Exception catch(e, stackTrace){
      return '';
    }
  }

  static String getLocalTime(String date){
    try{
      var dateTime = getDateFromString(date);
      return DateFormat.jm().format(dateTime);
    } on Exception catch(e, stackTrace){
      return '';
    }
  }


  static String getHalfMonthDateFormat(String date, {isTimeRequired = false}){
    try {
      var dateTime = getDateFromString(date);
      var day = dateTime.day;
      var month = dateTime.month;
      var year = dateTime.year;

      if(isTimeRequired){
        return '$day $month $year, ${getTime(date)}';
      }
      return '$day $month)} $year';
    } on Exception catch (e) {
      return '';
    }
  }


  static String getCheckInDateFormat(DateTime date) {
    try{
      List<String> dateTime = date.toLocal().toString().split(' ');
      return '${dateTime.first}T${dateTime.last}Z';
    } on Exception catch(e){
      return '';
    }
  }


  static String getFollowUpTime(String date, String time) {
    if (date == null || date.trim().isEmpty) return '';

    try {
      DateFormat inputFormat;
      if(date.contains('-')){
        inputFormat = DateFormat('dd-MM-yyyy');
      }else{
        inputFormat = DateFormat('dd/MM/yyyy');
      }
      var inputDate = inputFormat.parse(date);
      List<String> dateTime = inputDate.toLocal().toString().split(' ');
      return '${dateTime.first}T$time:12.121Z';
    } on Exception catch (e) {
      return '';
    }
  }

}
