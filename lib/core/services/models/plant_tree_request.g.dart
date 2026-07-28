// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_tree_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantTreeRequest _$PlantTreeRequestFromJson(Map<String, dynamic> json) =>
    PlantTreeRequest(
      quantity: (json['quantity'] as num).toInt(),
      planterId: json['planter_id'] as String?,
      speciesId: (json['species_id'] as num?)?.toInt(),
      orderId: json['order_id'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$PlantTreeRequestToJson(PlantTreeRequest instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'planter_id': instance.planterId,
      'species_id': instance.speciesId,
      'order_id': instance.orderId,
      'message': instance.message,
    };
