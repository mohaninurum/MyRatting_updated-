import 'package:json_annotation/json_annotation.dart';
part 'subCategory_response.g.dart';
@JsonSerializable()
class SubCategoryResponse {
  bool? status;
  List<SubCategoryData>? data;

  SubCategoryResponse({this.status, this.data});

  factory SubCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$SubCategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubCategoryResponseToJson(this);

}
@JsonSerializable()
class SubCategoryData {
  int? subcategory_id_PK;
  int? category_id_FK;
  String? subcategory_name;
  String? description;
  String? icon;
  int? status;
  String? created_at;
  String? updated_at;
  String? category_name;

  SubCategoryData(
      {this.subcategory_id_PK,
        this.category_id_FK,
        this.subcategory_name,
        this.description,
        this.icon,
        this.status,
        this.created_at,
        this.updated_at,
        this.category_name});
  factory SubCategoryData.fromJson(Map<String, dynamic> json) =>
      _$SubCategoryDataFromJson(json);

  Map<String, dynamic> toJson() => _$SubCategoryDataToJson(this);


}