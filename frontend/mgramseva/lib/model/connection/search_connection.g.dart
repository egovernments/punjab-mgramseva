// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchConnection _$SearchConnectionFromJson(Map<String, dynamic> json) {
  return SearchConnection()
    ..oldConnectionNo = json['oldConnectionNo'] as String?
    ..name = json['name'] as String?
    ..connectionNo = json['connectionNo'] as String?
    ..mobileNumber = json['mobileNumber'] as String?;
}

Map<String, dynamic> _$SearchConnectionToJson(SearchConnection instance) =>
    <String, dynamic>{
      'oldConnectionNo': instance.oldConnectionNo,
      'name': instance.name,
      'connectionNo': instance.connectionNo,
      'mobileNumber': instance.mobileNumber,
    };
