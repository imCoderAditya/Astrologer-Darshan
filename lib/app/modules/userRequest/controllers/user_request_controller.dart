import 'dart:convert';

import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/userRequest/user_request_model.dart';
import 'package:astrology/app/data/repositories/userRequest/user_request_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserRequestController extends GetxController {
  var isLoading = false.obs;
  Rxn<UserRequestModel> userRequestModel = Rxn<UserRequestModel>();
  UserRequestReposites userRequestReposites = UserRequestReposites();

  Future<void> fetchUserRequest({String? status, String? sessionType}) async {
    isLoading.value = true;
    try {
      final res = await userRequestReposites.fetchUserRequest(
        status: status,
        sessionType: sessionType,
      );

      if (res != null) {
        userRequestModel.value = userRequestModelFromJson(
          json.encode(res.data),
        );
      } else {
        LoggerUtils.error("Failed ${res.data}");
      }
    } catch (e) {
      LoggerUtils.debug("Error: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> statusUpdate(String? status, int? sessionId, String? sessionType) async {
    try {
      debugPrint(" sessionId ::::$sessionId");
      final res = await BaseClient.post(
        api: EndPoint.statusUpdate,
        data: {"SessionId": sessionId, "Status": status},
      );

      if (res != null && res.statusCode == 200) {
        await fetchUserRequest(sessionType: sessionType??"");
      } else {
        LoggerUtils.error("Failed ${res.data}");
      }
    } catch (e) {
      LoggerUtils.debug("Error: $e");
    } finally {
      update();
    }
  }
}
