import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "gender")
  String? gender;

  @JsonKey(name: "phoneNumber")
  String? phoneNumber;

  @JsonKey(name: "emailId")
  String? emailId;

  @JsonKey(ignore: true)
  var nameCtrl = TextEditingController();

  @JsonKey(ignore: true)
  var phoneNumberCtrl = TextEditingController();

  @JsonKey(ignore: true)
  var emailIdCtrl = TextEditingController();

  UserProfile();

  setText() {
    name = nameCtrl.text;
    phoneNumber = phoneNumberCtrl.text;
    emailId = emailIdCtrl.text;
  }

  getText() {
    nameCtrl.text = name ?? '';
    phoneNumberCtrl.text = phoneNumber ?? '';
    emailIdCtrl.text = emailId ?? '';
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
