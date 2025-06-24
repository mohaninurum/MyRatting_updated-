import 'package:json_annotation/json_annotation.dart';
part 'get_report_response.g.dart';
@JsonSerializable()
class GetReportResponse {
  bool? status;
  String? message;
  List<ReportData>? data;

  GetReportResponse({this.status, this.message, this.data});

  factory GetReportResponse.fromJson(Map<String, dynamic> json) =>
      _$GetReportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetReportResponseToJson(this);

}

@JsonSerializable()
class ReportData {
  int? report_id_PK;
  int? user_id_FK;
  int? card_id_FK;
  String? reason;

  ReportData({this.report_id_PK, this.
  user_id_FK, this.card_id_FK,this.reason});
  factory ReportData.fromJson(Map<String, dynamic> json) =>
      _$ReportDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReportDataToJson(this);


}
