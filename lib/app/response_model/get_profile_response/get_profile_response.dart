import 'package:json_annotation/json_annotation.dart';
part 'get_profile_response.g.dart';
@JsonSerializable()
class GetProfileResponse {
  bool? status;
  String? message;
  ProfileData? data;

  GetProfileResponse({this.status, this.message, this.data});
  factory GetProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$GetProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetProfileResponseToJson(this);


}

@JsonSerializable()
class ProfileData {
  int? user_id_PK;
  String? email;
  String? full_name;
  String? password;
  String? image;
  int? role;
  String? age;
  String? otp;
  String? mobile_number;
  int? is_verified;
  int? is_login;
  String? token;
  String? otp_expiry;
  String? country_code;
  ProfileData(
      {this.user_id_PK,
        this.email,
        this.full_name,
        this.password,
        this.image,
        this.role,
        this.age,
        this.otp,
        this.mobile_number,
        this.is_verified,
        this.is_login,
        this.token,
        this.otp_expiry,
        this.country_code});
  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDataToJson(this);


}
