import 'package:json_annotation/json_annotation.dart';
import 'package:mgramseva/model/connection/water_connection.dart';
part 'water_connections.g.dart';

@JsonSerializable()
class WaterConnections {
  @JsonKey(name: "waterConnection")
  List<WaterConnection>? waterConnection;

  WaterConnections();

  factory WaterConnections.fromJson(Map<String, dynamic> json) =>
      _$WaterConnectionsFromJson(json);
  Map<String, dynamic> toJson() => _$WaterConnectionsToJson(this);
}
