// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_tree_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantTreeResponse _$PlantTreeResponseFromJson(Map<String, dynamic> json) =>
    PlantTreeResponse(
      id: (json['id'] as num?)?.toInt(),
      treeId: (json['tree_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      url: json['url'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$PlantTreeResponseToJson(PlantTreeResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tree_id': instance.treeId,
      'name': instance.name,
      'url': instance.url,
      'message': instance.message,
    };
