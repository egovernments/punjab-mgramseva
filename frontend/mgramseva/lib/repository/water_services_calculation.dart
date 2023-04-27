import 'package:json_annotation/json_annotation.dart';

import '../model/mdms/WCBillingSlab.dart';

part 'water_services_calculation.g.dart';

@JsonSerializable()
class WCBillingSlabs {
  @JsonKey(name: "WCBillingSlab")
  late List<WCBillingSlab> wCBillingSlabs;

  WCBillingSlabs();

  factory WCBillingSlabs.fromJson(Map<String, dynamic> json) =>
      _$WCBillingSlabsFromJson(json);

  Map<String, dynamic> toJson() => _$WCBillingSlabsToJson(this);
}
