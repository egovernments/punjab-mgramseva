import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import 'package:mgramseva/utils/date_formats.dart';

part 'vendor.g.dart';

@JsonSerializable()
class Vendor {

  @JsonKey(name: "name")
  String name;

  @JsonKey(name: "id")
  String id;

  Vendor(this.name, this.id);

  factory Vendor.fromJson(Map<String, dynamic> json) =>
      _$VendorFromJson(json);

  Map<String, dynamic> toJson() => _$VendorToJson(this);
}