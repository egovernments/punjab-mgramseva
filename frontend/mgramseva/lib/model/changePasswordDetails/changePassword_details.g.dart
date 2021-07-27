// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'changePassword_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangePasswordDetails _$ChangePasswordDetailsFromJson(
    Map<String, dynamic> json) {
  return ChangePasswordDetails()
    ..existingPassword = json['existingPassword'] as String?
    ..newPassword = json['newPassword'] as String?
    ..mobileNumber = json['mobileNumber'] as String?
    ..tenantId = json['tenantId'] as String?
    ..type = json['type'] as String?;
}

Map<String, dynamic> _$ChangePasswordDetailsToJson(
        ChangePasswordDetails instance) =>
    <String, dynamic>{
      'existingPassword': instance.existingPassword,
      'newPassword': instance.newPassword,
      'mobileNumber': instance.mobileNumber,
      'tenantId': instance.tenantId,
      'type': instance.type,
    };
