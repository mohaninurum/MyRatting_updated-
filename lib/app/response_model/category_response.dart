import 'package:json_annotation/json_annotation.dart';

part 'category_response.g.dart';
@JsonSerializable()
class CategoryResponse {
  bool? status;
  String? message;
  List<CategoryData>? data;

  CategoryResponse({this.status, this.message, this.data});
  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryResponseToJson(this);

}
@JsonSerializable()
class CategoryData {
  int? category_id_PK;
  String? category_name;
  String? description;
  String? icon;
  int? status;
  String? created_at;

  CategoryData(
      {this.category_id_PK,
        this.category_name,
        this.description,
        this.icon,
        this.status,
        this.created_at});

  factory CategoryData.fromJson(Map<String, dynamic> json) =>
      _$CategoryDataFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDataToJson(this);
}