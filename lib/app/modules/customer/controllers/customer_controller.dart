import 'dart:convert';

import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/followers/followers_model.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:get/get.dart';

class CustomerController extends GetxController {
  Rxn<FollowersModel> followersModel = Rxn<FollowersModel>();
  final astrologerId = LocalStorageService.getAstrologerId();

  Future<void> fetchCustomer() async {
    try {
      final res = await BaseClient.get(
        api: "${EndPoint.getFollowers}?astrologerid=$astrologerId",
      );

      if (res != null && res.statusCode == 200) {
        followersModel.value = followersModelFromJson(json.encode(res.data));
      } else {
        LoggerUtils.error("Failed: ${res?.data}");
      }
    } catch (e) {
      LoggerUtils.error("Error : $e");
    } finally {
      update();
    }
  }

  @override
  void onInit() {
    fetchCustomer();
    super.onInit();
  }
}
