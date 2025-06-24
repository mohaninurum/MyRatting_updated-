import 'package:json_annotation/json_annotation.dart';
part 'get_card_response.g.dart';
@JsonSerializable()
class GetCardResponse {
  bool? status;
  String? message;
  List<CardData>? data;

  GetCardResponse({this.status, this.message, this.data});
  factory GetCardResponse.fromJson(Map<String, dynamic> json) =>
      _$GetCardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetCardResponseToJson(this);


}
@JsonSerializable()
class CardData {
  int? card_id_PK;
  String? title;
  int? user_id_FK;
  String? description;
  int? category_id_FK;
  int? subcategory_id_FK;
  String? image;
  int? status;
  String? country_id_FK;
  String? created_at;
  String? updated_at;
  String? additional_information;
  String? category_name;
  String? subcategory_name;
  String? country_names;
  int? is_like;
  int? is_superlike;
  int? is_dislike;
  CardData(
      {this.card_id_PK,
        this.title,
        this.user_id_FK,
        this.description,
        this.category_id_FK,
        this.subcategory_id_FK,
        this.image,
        this.status,
        this.country_id_FK,
        this.created_at,
        this.updated_at,
        this.additional_information,
        this.category_name,
        this.subcategory_name,
        this.country_names,
        this.is_dislike,
        this.is_like,
        this.is_superlike});
  factory CardData.fromJson(Map<String, dynamic> json) =>
      _$CardDataFromJson(json);

  Map<String, dynamic> toJson() => _$CardDataToJson(this);


}
