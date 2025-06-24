import 'package:card/app/utils/appFonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../response_model/notification_response/notification_response.dart';
import '../../utils/appColors.dart';


import 'notifcation_controller.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Notifications',
          style: AppFonts.rubik.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios),
          onTap: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoader.value) {
          return const Center(child: CupertinoActivityIndicator());
        }

        if (controller.notificationData.isEmpty) {
          return Center(
            child: Text(
              "No notifications found.",
              style: AppFonts.rubik.copyWith(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView(
          children: [
            if (controller.todayNotifications.isNotEmpty) ...[
              sectionTitle('Today'),
              ...controller.todayNotifications.map((n) => notificationTile(n, controller)),
            ],
            if (controller.yesterdayNotifications.isNotEmpty) ...[
              sectionTitle('Yesterday'),
              ...controller.yesterdayNotifications.map((n) => notificationTile(n, controller)),
            ],
            if (controller.last7DaysNotifications.isNotEmpty) ...[
              sectionTitle('Last 7 Days'),
              ...controller.last7DaysNotifications.map((n) => notificationTile(n, controller)),
            ],
            if (controller.last30DaysNotifications.isNotEmpty) ...[
              sectionTitle('Last 30 Days'),
              ...controller.last30DaysNotifications.map((n) => notificationTile(n, controller)),
            ],
          ],
        );
      }),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: AppFonts.rubik.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget notificationTile(NotificationsData notification, NotificationController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.primaryColor,
            child: const Icon(Icons.notifications, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title ?? '',
                  style: AppFonts.rubik.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notification.body ?? '',
                        style: AppFonts.rubik.copyWith(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      controller.formatDate(notification.created_at ?? ''),
                      style: AppFonts.rubik.copyWith(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
