import 'dart:math';

class Department {
  final String id;
  final String tenantId;
  final String departmentId;
  final String code;
  final String name;
  final int hierarchyLevel;
  late final List<Department> children;

  Department({
    required this.id,
    required this.tenantId,
    required this.departmentId,
    required this.code,
    required this.name,
    required this.hierarchyLevel,
    List<Department>? children,
  }) : children = children ?? [];

  factory Department.fromJson(Map<String, dynamic> json) {
    final childrenJson = json['children'] as List<dynamic>;
    return Department(
      id: json['id']??'',
      tenantId: json['tenantId']??'',
      departmentId: json['departmentId']??'',
      code: json['code']??'',
      name: json['name']??'',
      hierarchyLevel: json['hierarchyLevel'] ?? Random().nextInt(500)+50,
      children: childrenJson.map((childJson) => Department.fromJson(childJson)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenantId': tenantId,
      'departmentId': departmentId,
      'code': code,
      'name': name,
      'hierarchyLevel': hierarchyLevel,
      'children': List<Map<String, dynamic>>.from(children.map((child) => child.toJson())),
    };
  }
}