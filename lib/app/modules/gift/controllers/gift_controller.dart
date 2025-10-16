import 'dart:convert';

import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/gift/gift_model.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:get/get.dart';

class GiftController extends GetxController {
  RxBool isLoading = false.obs;
  Rxn<GiftModel> giftModel = Rxn<GiftModel>();

  final userId = LocalStorageService.getUserId();

  Future<void> fetchGift() async {
    isLoading.value = true;
    try {
      final res = await BaseClient.get(
        api:
            "${EndPoint.getGiftTransactions}?sessionid=0&senderId=0&receiverId=$userId",
      );
      if (res != null && res.statusCode == 200) {
        giftModel.value = giftModelFromJson(json.encode(res.data));
        LoggerUtils.debug("Response: ${json.encode(giftModel.value)}");
      } else {
        LoggerUtils.error("Failed: ${res?.data}");
      }
    } catch (e) {
      LoggerUtils.error("Error : $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  @override
  void onInit() {
    fetchGift();
    super.onInit();
  }
}
