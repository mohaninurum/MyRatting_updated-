// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryResponse _$CategoryResponseFromJson(Map<String, dynamic> json) =>
    CategoryResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CategoryData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryResponseToJson(CategoryResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

CategoryData _$CategoryDataFromJson(Map<String, dynamic> json) => CategoryData(
      category_id_PK: (json['category_id_PK'] as num?)?.toInt(),
      category_name: json['category_name'] as String?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      status: (json['status'] as num?)?.toInt(),
      created_at: json['created_at'] as String?,
    );

Map<String, dynamic> _$CategoryDataToJson(CategoryData instance) =>
    <String, dynamic>{
      'category_id_PK': instance.category_id_PK,
      'category_name': instance.category_name,
      'description': instance.description,
      'icon': instance.icon,
      'status': instance.status,
      'created_at': instance.created_at,
    };
