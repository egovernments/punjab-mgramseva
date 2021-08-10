// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_connections.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaterConnections _$WaterConnectionsFromJson(Map<String, dynamic> json) {
  return WaterConnections()
    ..waterConnection = (json['waterConnection'] as List<dynamic>?)
        ?.map((e) => WaterConnection.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$WaterConnectionsToJson(WaterConnections instance) =>
    <String, dynamic>{
      'waterConnection': instance.waterConnection,
    };
