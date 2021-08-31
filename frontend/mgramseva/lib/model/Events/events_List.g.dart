// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_List.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventsList _$EventsListFromJson(Map<String, dynamic> json) {
  return EventsList()
    ..events = (json['events'] as List<dynamic>?)
        ?.map((e) => Events.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$EventsListToJson(EventsList instance) =>
    <String, dynamic>{
      'events': instance.events,
    };

Events _$EventsFromJson(Map<String, dynamic> json) {
  return Events()
    ..tenantId = json['tenantId'] as String?
    ..id = json['id'] as String?
    ..referenceId = json['referenceId'] as String?
    ..eventType = json['eventType'] as String?
    ..eventCategory = json['eventCategory'] as String?
    ..name = json['name'] as String?
    ..description = json['description'] as String?
    ..status = json['status'] as String?
    ..source = json['source'] as String?
    ..postedBy = json['postedBy'] as String?
    ..recepient = json['recepient'] == null
        ? null
        : Recepient.fromJson(json['recepient'] as Map<String, dynamic>)
    ..actions = json['actions'] as String?
    ..eventDetails = json['eventDetails'] as String?
    ..auditDetails = json['auditDetails'] == null
        ? null
        : AuditDetails.fromJson(json['auditDetails'] as Map<String, dynamic>)
    ..recepientEventMap = json['recepientEventMap'] as String?
    ..generateCounterEvent = json['generateCounterEvent'] as String?
    ..internallyUpdted = json['internallyUpdted'] as String?;
}

Map<String, dynamic> _$EventsToJson(Events instance) => <String, dynamic>{
      'tenantId': instance.tenantId,
      'id': instance.id,
      'referenceId': instance.referenceId,
      'eventType': instance.eventType,
      'eventCategory': instance.eventCategory,
      'name': instance.name,
      'description': instance.description,
      'status': instance.status,
      'source': instance.source,
      'postedBy': instance.postedBy,
      'recepient': instance.recepient,
      'actions': instance.actions,
      'eventDetails': instance.eventDetails,
      'auditDetails': instance.auditDetails,
      'recepientEventMap': instance.recepientEventMap,
      'generateCounterEvent': instance.generateCounterEvent,
      'internallyUpdted': instance.internallyUpdted,
    };

AuditDetails _$AuditDetailsFromJson(Map<String, dynamic> json) {
  return AuditDetails()
    ..createdBy = json['createdBy'] as String?
    ..createdTime = json['createdTime'] as int?
    ..lastModifiedBy = json['lastModifiedBy'] as String?
    ..lastModifiedTime = json['lastModifiedTime'] as int?;
}

Map<String, dynamic> _$AuditDetailsToJson(AuditDetails instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdTime': instance.createdTime,
      'lastModifiedBy': instance.lastModifiedBy,
      'lastModifiedTime': instance.lastModifiedTime,
    };

Recepient _$RecepientFromJson(Map<String, dynamic> json) {
  return Recepient(
    toRoles: json['toRoles'] as String?,
    toUsers:
        (json['toUsers'] as List<dynamic>?)?.map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$RecepientToJson(Recepient instance) => <String, dynamic>{
      'toRoles': instance.toRoles,
      'toUsers': instance.toUsers,
    };
