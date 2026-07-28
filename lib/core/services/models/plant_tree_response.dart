import 'package:json_annotation/json_annotation.dart';

part 'plant_tree_response.g.dart';

@JsonSerializable()
class PlantTreeResponse {
  final int? id;
  
  @JsonKey(name: 'tree_id')
  final int? treeId;

  final String? name;
  final String? url;
  
  final String? message;

  PlantTreeResponse({
    this.id,
    this.treeId,
    this.name,
    this.url,
    this.message,
  });

  factory PlantTreeResponse.fromJson(Map<String, dynamic> json) => _$PlantTreeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PlantTreeResponseToJson(this);
}
