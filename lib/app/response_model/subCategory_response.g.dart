// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subCategory_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubCategoryResponse _$SubCategoryResponseFromJson(Map<String, dynamic> json) =>
    SubCategoryResponse(
      status: json['status'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SubCategoryData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubCategoryResponseToJson(
        SubCategoryResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

SubCategoryData _$SubCategoryDataFromJson(Map<String, dynamic> json) =>
    SubCategoryData(
      subcategory_id_PK: (json['subcategory_id_PK'] as num?)?.toInt(),
      category_id_FK: (json['category_id_FK'] as num?)?.toInt(),
      subcategory_name: json['subcategory_name'] as String?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      status: (json['status'] as num?)?.toInt(),
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
      category_name: json['category_name'] as String?,
    );

Map<String, dynamic> _$SubCategoryDataToJson(SubCategoryData instance) =>
    <String, dynamic>{
      'subcategory_id_PK': instance.subcategory_id_PK,
      'category_id_FK': instance.category_id_FK,
      'subcategory_name': instance.subcategory_name,
      'description': instance.description,
      'icon': instance.icon,
      'status': instance.status,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'category_name': instance.category_name,
    };
