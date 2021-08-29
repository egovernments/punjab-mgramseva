// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_connections.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaterConnections _$WaterConnectionsFromJson(Map<String, dynamic> json) {
  return WaterConnections()
    ..waterConnection = (json['WaterConnection'] as List<dynamic>?)
        ?.map((e) => WaterConnection.fromJson(e as Map<String, dynamic>))
        .toList()
    ..totalCount = json['totalCount'] as int? ?? 0;
}

Map<String, dynamic> _$WaterConnectionsToJson(WaterConnections instance) =>
    <String, dynamic>{
      'WaterConnection': instance.waterConnection,
      'totalCount': instance.totalCount,
    };
