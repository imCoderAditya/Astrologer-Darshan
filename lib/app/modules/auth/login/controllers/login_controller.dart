// lib/controllers/login_controller.dart

import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/routes/app_pages.dart';
import 'package:astrology/components/snack_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_form_field/phone_form_field.dart';

class LoginController extends GetxController {
  // Phone field controller
  PhoneController phoneController = PhoneController(
    initialValue: PhoneNumber(isoCode: IsoCode.IN, nsn: ""),
  );
  RxString? phoneNumber = RxString("");
  // Reactive variables
  var isLoading = false.obs;

  // Form key
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  bool isPhoneValid() {
    if (GetUtils.isPhoneNumber(phoneController.value.toString())) {
      _showErrorSnackbar('Please enter a valid mobile number');
      return false;
    }
    return true;
  }

  Future<void> onLoginPressed() async {
    if (!isPhoneValid()) return;
    try {
      isLoading.value = true;
      final response = await BaseClient.post(
        api: EndPoint.sendOTP,
        data: {"PhoneNumber": phoneController.value.nsn},
      );

      if (response != null && response.statusCode == 200) {
        if (response.data["Status"] == true) {
          SnackBarUiView.showSuccess(message: response.data["Message"] ?? "");
          Get.toNamed(
            Routes.OTP_VERIFY,
            arguments: {"phoneNumber": phoneController.value.nsn},
          );
        } else {
          LoggerUtils.error("Login Failed API");
        }
      } else {
        SnackBarUiView.showSuccess(message: response.data["Message"] ?? "");
      }
    } catch (e) {
      LoggerUtils.error('Something $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }
}
