import 'dart:convert';

import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/profile/profile_model.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  Rxn<ProfileModel> profileModel = Rxn<ProfileModel>();
  final userId = LocalStorageService.getUserId();
  Future<void> getProfile() async {
    try {
      final res = await BaseClient.get(
        api: "${EndPoint.fetchProfile}?userId=$userId",
      );

      if (res != null && res.statusCode == 200) {
        profileModel.value = profileModelFromJson(json.encode(res.data));
      } else {
        debugPrint("Failed Response ${res?.data}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      update();
    }
  }

  @override
  void onInit() {
    getProfile();
    super.onInit();
  }
}
