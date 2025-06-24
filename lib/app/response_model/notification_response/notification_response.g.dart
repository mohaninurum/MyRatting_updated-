// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetNotificationResponse _$GetNotificationResponseFromJson(
        Map<String, dynamic> json) =>
    GetNotificationResponse(
      status: json['status'] as bool?,
      notifications: (json['notifications'] as List<dynamic>?)
          ?.map((e) => NotificationsData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetNotificationResponseToJson(
        GetNotificationResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'notifications': instance.notifications,
    };

NotificationsData _$NotificationsDataFromJson(Map<String, dynamic> json) =>
    NotificationsData(
      notification_id_PK: (json['notification_id_PK'] as num?)?.toInt(),
      user_id_FK: (json['user_id_FK'] as num?)?.toInt(),
      title: json['title'] as String?,
      body: json['body'] as String?,
      created_at: json['created_at'] as String?,
    );

Map<String, dynamic> _$NotificationsDataToJson(NotificationsData instance) =>
    <String, dynamic>{
      'notification_id_PK': instance.notification_id_PK,
      'user_id_FK': instance.user_id_FK,
      'title': instance.title,
      'body': instance.body,
      'created_at': instance.created_at,
    };
