import 'package:json_annotation/json_annotation.dart';

part 'plant_tree_request.g.dart';

@JsonSerializable()
class PlantTreeRequest {
  @JsonKey(name: 'quantity')
  final int quantity;

  @JsonKey(name: 'planter_id')
  final String? planterId;
  
  @JsonKey(name: 'species_id')
  final int? speciesId;

  @JsonKey(name: 'order_id')
  final String? orderId;

  @JsonKey(name: 'message')
  final String? message;

  PlantTreeRequest({
    required this.quantity,
    this.planterId,
    this.speciesId,
    this.orderId,
    this.message,
  });

  factory PlantTreeRequest.fromJson(Map<String, dynamic> json) => _$PlantTreeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PlantTreeRequestToJson(this);
}
