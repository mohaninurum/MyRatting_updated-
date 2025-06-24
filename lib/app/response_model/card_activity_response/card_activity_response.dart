import 'package:json_annotation/json_annotation.dart';
part 'card_activity_response.g.dart';
@JsonSerializable()
class CardActivityResponse {
  bool? status;
  String? message;
  List<CardActivityData>? data;

  CardActivityResponse({this.status, this.message, this.data});
  factory CardActivityResponse.fromJson(Map<String, dynamic> json) =>
      _$CardActivityResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CardActivityResponseToJson(this);


}
@JsonSerializable()
class CardActivityData {
  int? card_id_PK;
  String? title;
  int? user_id_FK;
  String? description;
  int? category_id_FK;
  int? subcategory_id_FK;
  String? image;
  String? country_id_FK;
  String? created_at;
  String? updated_at;
  String? additional_information;
  String? category_name;
  String? subcategory_name;
  int? is_like;
  int? is_superlike;
  int? is_dislike;
  CardActivityData(
      {this.card_id_PK,
        this.title,
        this.user_id_FK,
        this.description,
        this.category_id_FK,
        this.subcategory_id_FK,
        this.image,
        this.country_id_FK,
        this.created_at,
        this.updated_at,
        this.additional_information,
        this.category_name,
        this.subcategory_name,
        this.is_like,
        this. is_superlike,
        this. is_dislike});

  factory CardActivityData.fromJson(Map<String, dynamic> json) =>
      _$CardActivityDataFromJson(json);

  Map<String, dynamic> toJson() => _$CardActivityDataToJson(this);

}