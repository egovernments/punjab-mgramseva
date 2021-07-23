// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return UserProfile()
    ..name = json['name'] as String?
    ..gender = json['gender'] as String?
    ..phoneNumber = json['phoneNumber'] as String?
    ..emailId = json['emailId'] as String?;
}

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'name': instance.name,
      'gender': instance.gender,
      'phoneNumber': instance.phoneNumber,
      'emailId': instance.emailId,
    };
