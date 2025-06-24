// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetProfileResponse _$GetProfileResponseFromJson(Map<String, dynamic> json) =>
    GetProfileResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : ProfileData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetProfileResponseToJson(GetProfileResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

ProfileData _$ProfileDataFromJson(Map<String, dynamic> json) => ProfileData(
      user_id_PK: (json['user_id_PK'] as num?)?.toInt(),
      email: json['email'] as String?,
      full_name: json['full_name'] as String?,
      password: json['password'] as String?,
      image: json['image'] as String?,
      role: (json['role'] as num?)?.toInt(),
      age: json['age'] as String?,
      otp: json['otp'] as String?,
      mobile_number: json['mobile_number'] as String?,
      is_verified: (json['is_verified'] as num?)?.toInt(),
      is_login: (json['is_login'] as num?)?.toInt(),
      token: json['token'] as String?,
      otp_expiry: json['otp_expiry'] as String?,
      country_code: json['country_code'] as String?,
    );

Map<String, dynamic> _$ProfileDataToJson(ProfileData instance) =>
    <String, dynamic>{
      'user_id_PK': instance.user_id_PK,
      'email': instance.email,
      'full_name': instance.full_name,
      'password': instance.password,
      'image': instance.image,
      'role': instance.role,
      'age': instance.age,
      'otp': instance.otp,
      'mobile_number': instance.mobile_number,
      'is_verified': instance.is_verified,
      'is_login': instance.is_login,
      'token': instance.token,
      'otp_expiry': instance.otp_expiry,
      'country_code': instance.country_code,
    };
