import 'package:json_annotation/json_annotation.dart';
part 'top_rated_response.g.dart';
@JsonSerializable()
class TopRatedResponse {
  bool? success;
  String? message;
  List<TopData>? data;

  TopRatedResponse({this.success, this.message, this.data});

  factory TopRatedResponse.fromJson(Map<String, dynamic> json) =>
      _$TopRatedResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TopRatedResponseToJson(this);

}

@JsonSerializable()
class TopData {
  int? card_id_FK;
  String? title;
  String? description;
  String? image;
  String? likes;
  String? superlikes;
  String? total_score;

  TopData(
      {this.card_id_FK,
        this.title,
        this.description,
        this.image,
        this.likes,
        this.superlikes,
        this.total_score});
  factory TopData.fromJson(Map<String, dynamic> json) =>
      _$TopDataFromJson(json);

  Map<String, dynamic> toJson() => _$TopDataToJson(this);


}
