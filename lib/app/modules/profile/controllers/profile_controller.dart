import 'dart:convert';
import 'dart:developer';

import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/profile/profile_model.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:astrology/components/global_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  Rxn<ProfileModel> profileModel = Rxn<ProfileModel>();

  Future<void> getProfile() async {
    final userId = LocalStorageService.getUserId();
    try {
      final res = await BaseClient.get(
        api: "${EndPoint.fetchProfile}?userId=$userId",
      );

      if (res != null && res.statusCode == 200) {
        profileModel.value = profileModelFromJson(json.encode(res.data));
        log("Profile :${json.encode(profileModel.value)}");
      } else {
        debugPrint("Failed Response ${res?.data}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      update();
    }
  }

  Future<void> onlineOffline({bool? isOnline}) async {
    GlobalLoader.show();
    final astrologerId = LocalStorageService.getAstrologerId();
    try {
      final res = await BaseClient.post(
        api: EndPoint.onlineUpdateStatus,
        data: {
          "AstrologerId": int.tryParse(astrologerId.toString()),
          "IsOnline": isOnline,
        },
      );

      if (res != null && res.statusCode == 201) {
        log("Profile :${json.encode(profileModel.value)}");
        getProfile();
      } else {
        debugPrint("Failed Response ${res?.data}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      GlobalLoader.hide();
      update();
    }
  }

  @override
  void onInit() {
    getProfile();
    super.onInit();
  }
}
