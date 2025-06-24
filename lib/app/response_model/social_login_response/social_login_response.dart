import 'package:json_annotation/json_annotation.dart';
part 'social_login_response.g.dart';
@JsonSerializable()
class SocialLoginResponse {
  bool? status;
  String? message;
  String? token;

  SocialLoginResponse({this.status, this.message, this.token});
  factory SocialLoginResponse.fromJson(Map<String, dynamic> json) =>
      _$SocialLoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SocialLoginResponseToJson(this);

}