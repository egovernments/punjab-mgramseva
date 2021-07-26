import 'package:json_annotation/json_annotation.dart';

part 'changePassword_details.g.dart';

@JsonSerializable()
class ChangePasswordDetails {
  @JsonKey(name: "existingPassword")
  String? existingPassword;
  @JsonKey(name: "newPassword")
  String? newPassword;
  @JsonKey(name: "mobileNumber")
  String? mobileNumber;
  @JsonKey(name: "tenantId")
  String? tenantId;
  @JsonKey(name: "type")
  String? type;

  ChangePasswordDetails();

  factory ChangePasswordDetails.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordDetailsToJson(this);

}