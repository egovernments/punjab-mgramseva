import 'package:json_annotation/json_annotation.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
part 'water_connections.g.dart';

@JsonSerializable()
class WaterConnections {
  @JsonKey(name: "WaterConnection")
  List<WaterConnection>? waterConnection;

  @JsonKey(name: "propertyCount")
  Map<String, dynamic>? tabData;

  @JsonKey(name: "totalCount", defaultValue: 0)
  int? totalCount;

  WaterConnections();

  factory WaterConnections.fromJson(Map<String, dynamic> json) =>
      _$WaterConnectionsFromJson(json);
  Map<String, dynamic> toJson() => _$WaterConnectionsToJson(this);
}
