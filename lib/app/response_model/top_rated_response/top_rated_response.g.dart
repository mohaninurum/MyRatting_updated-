// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_rated_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopRatedResponse _$TopRatedResponseFromJson(Map<String, dynamic> json) =>
    TopRatedResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TopData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TopRatedResponseToJson(TopRatedResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

TopData _$TopDataFromJson(Map<String, dynamic> json) => TopData(
      card_id_FK: (json['card_id_FK'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      likes: json['likes'] as String?,
      superlikes: json['superlikes'] as String?,
      total_score: json['total_score'] as String?,
    );

Map<String, dynamic> _$TopDataToJson(TopData instance) => <String, dynamic>{
      'card_id_FK': instance.card_id_FK,
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
      'likes': instance.likes,
      'superlikes': instance.superlikes,
      'total_score': instance.total_score,
    };
