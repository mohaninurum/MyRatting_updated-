import 'package:get/get.dart';

import '../../api_manager/api_client.dart';
import '../../api_manager/api_endPoints.dart';
import '../../app_service/app_service.dart';
import '../../response_model/notification_response/notification_response.dart';
import '../../utils/appUtils.dart';
import '../../utils/secure_storage.dart';



class NotificationController extends GetxController {
  ApiClient apiClient = ApiClient();
  RxBool isLoader = false.obs;
  RxList<NotificationsData> notificationData = <NotificationsData>[].obs;

  RxList<NotificationsData> todayNotifications = <NotificationsData>[].obs;
  RxList<NotificationsData> yesterdayNotifications = <NotificationsData>[].obs;
  RxList<NotificationsData> last7DaysNotifications = <NotificationsData>[].obs;
  RxList<NotificationsData> last30DaysNotifications = <NotificationsData>[].obs;
  @override
  void onInit() {
    super.onInit();
    getNotification();
  }
  Future<void> getNotification() async {
    final isConnected = await AppService.checkInternetConnectivity();
    if (!isConnected) {
      isLoader.value = false;
      return;
    }

    String authToken = await SecureStorage().readSecureData("token");

    try {
      isLoader.value = true;

      Map<String, String> header = {
        "Authorization": "Bearer $authToken",
        'Content-Type': 'application/json',
      };

      Response response = await apiClient.getData(
        ApiEndPoints.NOTIFICATION,
        headers: header,
        handleError: false,
      );

      if (response.statusCode == 200) {
        final notificationResponse = GetNotificationResponse.fromJson(response.body);
        notificationData.value = notificationResponse.notifications ?? [];

        categorizeNotifications();
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        AppUtils.appService.userSessionExpire();
      }
    } catch (e) {
      print("Error fetching notification data: $e");
    } finally {
      isLoader.value = false;
      update();
    }
  }

  void categorizeNotifications() {
    todayNotifications.clear();
    yesterdayNotifications.clear();
    last7DaysNotifications.clear();
    last30DaysNotifications.clear();

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(Duration(days: 1));
    DateTime sevenDaysAgo = today.subtract(Duration(days: 7));
    DateTime thirtyDaysAgo = today.subtract(Duration(days: 30));

    for (var notification in notificationData) {
      if (notification.created_at != null) {
        DateTime createdAt = DateTime.parse(notification.created_at!).toLocal();

        if (isSameDate(createdAt, today)) {
          todayNotifications.add(notification);
        } else if (isSameDate(createdAt, yesterday)) {
          yesterdayNotifications.add(notification);
        } else if (createdAt.isAfter(sevenDaysAgo)) {
          last7DaysNotifications.add(notification);
        } else if (createdAt.isAfter(thirtyDaysAgo)) {
          last30DaysNotifications.add(notification);
        }
      }
    }
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString).toLocal();
    return "${date.day} ${getMonthName(date.month)} ${date.year}";
  }

  String getMonthName(int monthNumber) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[monthNumber];
  }

}


