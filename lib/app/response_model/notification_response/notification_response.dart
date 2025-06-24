import 'package:json_annotation/json_annotation.dart';
part 'notification_response.g.dart';
@JsonSerializable()
class GetNotificationResponse {
  bool? status;
  List<NotificationsData>? notifications;

  GetNotificationResponse({this.status, this.notifications});
  factory GetNotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$GetNotificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetNotificationResponseToJson(this);

}
@JsonSerializable()
class NotificationsData {
  int? notification_id_PK;
  int? user_id_FK;
  String? title;
  String? body;
  String? created_at;

  NotificationsData(
      {this.notification_id_PK,
        this.user_id_FK,
        this.title,
        this.body,
        this.created_at});
  factory NotificationsData.fromJson(Map<String, dynamic> json) =>
      _$NotificationsDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsDataToJson(this);

}