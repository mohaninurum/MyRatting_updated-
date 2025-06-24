// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_card_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCardResponse _$GetCardResponseFromJson(Map<String, dynamic> json) =>
    GetCardResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CardData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetCardResponseToJson(GetCardResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

CardData _$CardDataFromJson(Map<String, dynamic> json) => CardData(
      card_id_PK: (json['card_id_PK'] as num?)?.toInt(),
      title: json['title'] as String?,
      user_id_FK: (json['user_id_FK'] as num?)?.toInt(),
      description: json['description'] as String?,
      category_id_FK: (json['category_id_FK'] as num?)?.toInt(),
      subcategory_id_FK: (json['subcategory_id_FK'] as num?)?.toInt(),
      image: json['image'] as String?,
      status: (json['status'] as num?)?.toInt(),
      country_id_FK: json['country_id_FK'] as String?,
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
      additional_information: json['additional_information'] as String?,
      category_name: json['category_name'] as String?,
      subcategory_name: json['subcategory_name'] as String?,
      country_names: json['country_names'] as String?,
      is_dislike: (json['is_dislike'] as num?)?.toInt(),
      is_like: (json['is_like'] as num?)?.toInt(),
      is_superlike: (json['is_superlike'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CardDataToJson(CardData instance) => <String, dynamic>{
      'card_id_PK': instance.card_id_PK,
      'title': instance.title,
      'user_id_FK': instance.user_id_FK,
      'description': instance.description,
      'category_id_FK': instance.category_id_FK,
      'subcategory_id_FK': instance.subcategory_id_FK,
      'image': instance.image,
      'status': instance.status,
      'country_id_FK': instance.country_id_FK,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'additional_information': instance.additional_information,
      'category_name': instance.category_name,
      'subcategory_name': instance.subcategory_name,
      'country_names': instance.country_names,
      'is_like': instance.is_like,
      'is_superlike': instance.is_superlike,
      'is_dislike': instance.is_dislike,
    };
