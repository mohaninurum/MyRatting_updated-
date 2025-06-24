import 'package:json_annotation/json_annotation.dart';
part 'country_response.g.dart';
@JsonSerializable()
class CountyListResponse {
  bool? status;
  String? message;
  List<CountryData>? data;

  CountyListResponse({this.status, this.message, this.data});
  factory CountyListResponse.fromJson(Map<String, dynamic> json) =>
      _$CountyListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CountyListResponseToJson(this);


}

@JsonSerializable()
class CountryData {
  int? country_id_PK;
  String? vSortname;
  String? country_name;
  int? iCountryCode;
  String? flag;
  String? eStatus;

  CountryData(
      {this.country_id_PK,
        this.vSortname,
        this.country_name,
        this.iCountryCode,
        this.flag,
        this.eStatus});
  factory CountryData.fromJson(Map<String, dynamic> json) =>
      _$CountryDataFromJson(json);

  Map<String, dynamic> toJson() => _$CountryDataToJson(this);


}
