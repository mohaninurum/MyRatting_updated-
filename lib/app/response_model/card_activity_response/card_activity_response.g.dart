// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_activity_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardActivityResponse _$CardActivityResponseFromJson(
        Map<String, dynamic> json) =>
    CardActivityResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CardActivityData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CardActivityResponseToJson(
        CardActivityResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

CardActivityData _$CardActivityDataFromJson(Map<String, dynamic> json) =>
    CardActivityData(
      card_id_PK: (json['card_id_PK'] as num?)?.toInt(),
      title: json['title'] as String?,
      user_id_FK: (json['user_id_FK'] as num?)?.toInt(),
      description: json['description'] as String?,
      category_id_FK: (json['category_id_FK'] as num?)?.toInt(),
      subcategory_id_FK: (json['subcategory_id_FK'] as num?)?.toInt(),
      image: json['image'] as String?,
      country_id_FK: json['country_id_FK'] as String?,
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
      additional_information: json['additional_information'] as String?,
      category_name: json['category_name'] as String?,
      subcategory_name: json['subcategory_name'] as String?,
      is_like: (json['is_like'] as num?)?.toInt(),
      is_superlike: (json['is_superlike'] as num?)?.toInt(),
      is_dislike: (json['is_dislike'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CardActivityDataToJson(CardActivityData instance) =>
    <String, dynamic>{
      'card_id_PK': instance.card_id_PK,
      'title': instance.title,
      'user_id_FK': instance.user_id_FK,
      'description': instance.description,
      'category_id_FK': instance.category_id_FK,
      'subcategory_id_FK': instance.subcategory_id_FK,
      'image': instance.image,
      'country_id_FK': instance.country_id_FK,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'additional_information': instance.additional_information,
      'category_name': instance.category_name,
      'subcategory_name': instance.subcategory_name,
      'is_like': instance.is_like,
      'is_superlike': instance.is_superlike,
      'is_dislike': instance.is_dislike,
    };
