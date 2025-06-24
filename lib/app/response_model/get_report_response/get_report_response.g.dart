// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetReportResponse _$GetReportResponseFromJson(Map<String, dynamic> json) =>
    GetReportResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ReportData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetReportResponseToJson(GetReportResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

ReportData _$ReportDataFromJson(Map<String, dynamic> json) => ReportData(
      report_id_PK: (json['report_id_PK'] as num?)?.toInt(),
      user_id_FK: (json['user_id_FK'] as num?)?.toInt(),
      card_id_FK: (json['card_id_FK'] as num?)?.toInt(),
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$ReportDataToJson(ReportData instance) =>
    <String, dynamic>{
      'report_id_PK': instance.report_id_PK,
      'user_id_FK': instance.user_id_FK,
      'card_id_FK': instance.card_id_FK,
      'reason': instance.reason,
    };
