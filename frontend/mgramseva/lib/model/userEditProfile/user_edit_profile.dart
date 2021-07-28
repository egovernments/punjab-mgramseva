import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mgramseva/model/user/user_details.dart';

part 'user_edit_profile.g.dart';


@JsonSerializable()
class EditUser {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "userName")
  String? userName;

  @JsonKey(name: "salutation")
  String? salutation;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "gender")
  String? gender;

  @JsonKey(name: "mobileNumber")
  String? mobileNumber;

  @JsonKey(name: "emailId")
  String? emailId;

  @JsonKey(name: "altContactNumber")
  String? altContactNumber;

  @JsonKey(name: "pan")
  String? pan;

  @JsonKey(name: "aadhaarNumber")
  String? aadhaarNumber;

  @JsonKey(name: "permanentAddress")
  String? permanentAddress;

  @JsonKey(name: "permanentCity")
  String? permanentCity;

  @JsonKey(name: "permanentPinCode")
  String? permanentPinCode;

  @JsonKey(name: "correspondenceAddress")
  String? correspondenceAddress;

  @JsonKey(name: "correspondenceCity")
  String? correspondenceCity;

  @JsonKey(name: "correspondencePinCode")
  String? correspondencePinCode;

  @JsonKey(name: "active")
  bool? active;

  @JsonKey(name: "locale")
  String? locale;

  @JsonKey(name: "type")
  String? type;

  @JsonKey(name: "accountLocked")
  bool? accountLocked;

  @JsonKey(name: "accountLockedDate")
  int? accountLockedDate;

  @JsonKey(name: "fatherOrHusbandName")
  String? fatherOrHusbandName;

  @JsonKey(name: "relationship")
  String? relationship;

  @JsonKey(name: "signature")
  String? signature;

  @JsonKey(name: "bloodGroup")
  String? bloodGroup;

  @JsonKey(name: "photo")
  String? photo;

  @JsonKey(name: "identificationMark")
  String? identificationMark;

  @JsonKey(name: "createdBy")
  int? createdBy;

  @JsonKey(name: "lastModifiedBy")
  int? lastModifiedBy;

  @JsonKey(name: "tenantId")
  String? tenantId;

  @JsonKey(name: "roles")
  List<Roles>? roles;

  @JsonKey(name: "uuid")
  String? uuid;

  @JsonKey(name: "createdDate")
  String? createdDate;

  @JsonKey(name: "lastModifiedDate")
  String? lastModifiedDate;

  @JsonKey(name: "dob")
  String? dob;

  @JsonKey(name: "pwdExpiryDate")
  String? pwdExpiryDate;

  @JsonKey(ignore: true)
  var nameCtrl = TextEditingController();

  @JsonKey(ignore: true)
  var phoneNumberCtrl = TextEditingController();

  @JsonKey(ignore: true)
  var emailIdCtrl = TextEditingController();

  EditUser();

  getText() {
    name = nameCtrl.text;
    emailId = emailIdCtrl.text;
  }

  factory EditUser.fromJson(Map<String, dynamic> json) => _$EditUserFromJson(json);

  Map<String, dynamic> toJson() => _$EditUserToJson(this);
}
