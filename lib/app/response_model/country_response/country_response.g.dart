// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountyListResponse _$CountyListResponseFromJson(Map<String, dynamic> json) =>
    CountyListResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CountryData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CountyListResponseToJson(CountyListResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

CountryData _$CountryDataFromJson(Map<String, dynamic> json) => CountryData(
      country_id_PK: (json['country_id_PK'] as num?)?.toInt(),
      vSortname: json['vSortname'] as String?,
      country_name: json['country_name'] as String?,
      iCountryCode: (json['iCountryCode'] as num?)?.toInt(),
      flag: json['flag'] as String?,
      eStatus: json['eStatus'] as String?,
    );

Map<String, dynamic> _$CountryDataToJson(CountryData instance) =>
    <String, dynamic>{
      'country_id_PK': instance.country_id_PK,
      'vSortname': instance.vSortname,
      'country_name': instance.country_name,
      'iCountryCode': instance.iCountryCode,
      'flag': instance.flag,
      'eStatus': instance.eStatus,
    };
