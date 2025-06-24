// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialLoginResponse _$SocialLoginResponseFromJson(Map<String, dynamic> json) =>
    SocialLoginResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$SocialLoginResponseToJson(
        SocialLoginResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'token': instance.token,
    };
