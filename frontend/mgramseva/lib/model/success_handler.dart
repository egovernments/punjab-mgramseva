import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'success_handler.g.dart';

@JsonSerializable()
class SuccessHandler {

  @JsonKey(name: "header")
  final String header;

  @JsonKey(name: "subtitle")
  final String subtitle;

  @JsonKey(name: "backButtonText")
  final String backButtonText;

  @JsonKey(name: "routeParentPath")
  final String routeParentPath;

  SuccessHandler(this.header, this.subtitle, this.backButtonText, this.routeParentPath);

  factory SuccessHandler.fromJson(Map<String, dynamic> json) =>
      _$SuccessHandlerFromJson(json);

  Map<String, dynamic> toJson() => _$SuccessHandlerToJson(this);
}