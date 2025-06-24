// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardDetailResponse _$CardDetailResponseFromJson(Map<String, dynamic> json) =>
    CardDetailResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CardDetailData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CardDetailResponseToJson(CardDetailResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

CardDetailData _$CardDetailDataFromJson(Map<String, dynamic> json) =>
    CardDetailData(
      card_id_PK: (json['card_id_PK'] as num?)?.toInt(),
      title: json['title'] as String?,
      user_id_FK: (json['user_id_FK'] as num?)?.toInt(),
      description: json['description'] as String?,
      category_id_FK: (json['category_id_FK'] as num?)?.toInt(),
      subcategory_id_FK: (json['subcategory_id_FK'] as num?)?.toInt(),
      image: json['image'] as String?,
      status: (json['status'] as num?)?.toInt(),
      country_id_FK: json['country_id_FK'] as String?,
      rej_card_by_admin: (json['rej_card_by_admin'] as num?)?.toInt(),
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
      additional_information: json['additional_information'] as String?,
      is_active: (json['is_active'] as num?)?.toInt(),
      category_name: json['category_name'] as String?,
      subcategory_name: json['subcategory_name'] as String?,
    );

Map<String, dynamic> _$CardDetailDataToJson(CardDetailData instance) =>
    <String, dynamic>{
      'card_id_PK': instance.card_id_PK,
      'title': instance.title,
      'user_id_FK': instance.user_id_FK,
      'description': instance.description,
      'category_id_FK': instance.category_id_FK,
      'subcategory_id_FK': instance.subcategory_id_FK,
      'image': instance.image,
      'status': instance.status,
      'country_id_FK': instance.country_id_FK,
      'rej_card_by_admin': instance.rej_card_by_admin,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'additional_information': instance.additional_information,
      'is_active': instance.is_active,
      'category_name': instance.category_name,
      'subcategory_name': instance.subcategory_name,
    };
