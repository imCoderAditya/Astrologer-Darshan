import 'dart:convert';

import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/notification/notification_model.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final userId = LocalStorageService.getUserId();
  var isLoading = false.obs;
  Rxn<NotificationModel> notificationModel = Rxn<NotificationModel>();
  Future<void> fetchNotification() async {
    isLoading.value = true;
    try {
      final res = await BaseClient.get(
        api: "${EndPoint.notifiaction}?userId=$userId",
      );

      if (res != null && res.statusCode == 200) {
        notificationModel.value = notificationModelFromJson(
          json.encode(res.data),
        );
      } else {
        LoggerUtils.error("Failed ${json.encode(res?.data)}");
      }
    } catch (e) {
      LoggerUtils.error("Error: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
