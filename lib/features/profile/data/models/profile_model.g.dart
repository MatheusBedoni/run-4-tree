// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
  name: json['name'] as String,
  email: json['email'] as String,
  avatarUrl: json['avatar_url'] as String?,
  treesPlanted: (json['trees_planted'] as num).toInt(),
  totalDistanceKm: (json['total_distance_km'] as num).toDouble(),
  memberSince: DateTime.parse(json['member_since'] as String),
);

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'avatar_url': instance.avatarUrl,
      'trees_planted': instance.treesPlanted,
      'total_distance_km': instance.totalDistanceKm,
      'member_since': instance.memberSince.toIso8601String(),
    };
