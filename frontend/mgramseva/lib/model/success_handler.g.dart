// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'success_handler.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuccessHandler _$SuccessHandlerFromJson(Map<String, dynamic> json) {
  return SuccessHandler(
    json['header'] as String,
    json['subtitle'] as String,
    json['backButtonText'] as String,
    json['routeParentPath'] as String,
  );
}

Map<String, dynamic> _$SuccessHandlerToJson(SuccessHandler instance) =>
    <String, dynamic>{
      'header': instance.header,
      'subtitle': instance.subtitle,
      'backButtonText': instance.backButtonText,
      'routeParentPath': instance.routeParentPath,
    };
