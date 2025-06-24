import 'package:json_annotation/json_annotation.dart';
part 'card_detail.g.dart';
@JsonSerializable()
class CardDetailResponse {
  bool? status;
  String? message;
  List<CardDetailData>? data;

  CardDetailResponse({this.status, this.message, this.data});
  factory CardDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$CardDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CardDetailResponseToJson(this);

}
@JsonSerializable()
class CardDetailData {
  int? card_id_PK;
  String? title;
  int? user_id_FK;
  String? description;
  int? category_id_FK;
  int? subcategory_id_FK;
  String? image;
  int? status;
  String? country_id_FK;
  int? rej_card_by_admin;
  String? created_at;
  String? updated_at;
  String? additional_information;
  int? is_active;
  String? category_name;
  String? subcategory_name;

  CardDetailData(
      {this.card_id_PK,
        this.title,
        this.user_id_FK,
        this.description,
        this.category_id_FK,
        this.subcategory_id_FK,
        this.image,
        this.status,
        this.country_id_FK,
        this.rej_card_by_admin,
        this.created_at,
        this.updated_at,
        this.additional_information,
        this.is_active,
        this.category_name,
        this.subcategory_name});
  factory CardDetailData.fromJson(Map<String, dynamic> json) =>
      _$CardDetailDataFromJson(json);

  Map<String, dynamic> toJson() => _$CardDetailDataToJson(this);


}