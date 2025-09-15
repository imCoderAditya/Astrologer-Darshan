import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/auth/otp_verify_model.dart';
import 'package:astrology/app/modules/auth/login/controllers/login_controller.dart';
import 'package:astrology/app/routes/app_pages.dart';
import 'package:astrology/app/services/firebase/firebase_services.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:astrology/components/Global_toast.dart';
import 'package:astrology/components/global_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:otp_pin_field/otp_pin_field.dart';

class OtpVerifyController extends GetxController {
  // OTP Field Key
  final GlobalKey<OtpPinFieldState> otpFieldKey = GlobalKey<OtpPinFieldState>();
  Rxn<OtpVerifyModel> otpVerifyModel = Rxn<OtpVerifyModel>();
  // Observable variables
  final RxString phoneNumber = ''.obs;
  final RxString otp = ''.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool canResend = false.obs;
  final RxInt resendTimer = 60.obs; // 60 seconds countdown

  final loginController =
      Get.isRegistered<LoginController>()
          ? Get.find<LoginController>()
          : Get.put(LoginController());
  // Timer
  Timer? _timer;

  bool? isUserExist;
  String? fmcToken;
  @override
  void onInit() {
    super.onInit();

    // Get phone number from arguments if passed
    phoneNumber.value = Get.arguments?['phoneNumber'] ?? '';
    debugPrint('Phone Number: ${phoneNumber.value}');

    getToken();
    // Start the resend timer
    startResendTimer();
    update();
  }

  void getToken() async {
    fmcToken = await FirebaseServices.firebaseToken();
  }

  @override
  void onClose() {
    // Cancel timer when controller is disposed
    _timer?.cancel();
    super.onClose();
  }

  // Start the resend timer
  void startResendTimer() {
    canResend.value = false;
    resendTimer.value = 60; // Reset to 60 seconds

    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  Future<void> verifyOtp() async {
    if (otp.value.trim().length < 6) {
      errorMessage.value = 'Please enter complete ${otp.value}-digit code';
      GlobalToast.showError(message: errorMessage.value);
      return;
    }
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await BaseClient.post(
        api: EndPoint.otpVerify,
        data: {
          "PhoneNumber": phoneNumber.value,
          "Otp": int.parse(otp.value),
          "Fcm": fmcToken,
        },
      );
      if (response != null) {
        otpVerifyModel.value = otpVerifyModelFromJson(
          json.encode(response.data),
        );
        log(json.encode(otpVerifyModel.value));
        if (otpVerifyModel.value?.status == true) {
          final userId = otpVerifyModel.value?.user?.userId.toString() ?? "";
          final astrologerId = otpVerifyModel.value?.user?.astrologerId;
          LocalStorageService.saveLogin(
            userId: userId,
            userAstrologerId: astrologerId,
          );
          debugPrint("UserId ===>$userId");
          debugPrint("UserId ===>$astrologerId");
          Get.offAllNamed(Routes.NAV);
        }
      } else {
        errorMessage.value = 'Invalid verification code. Please try again.';
      }
    } catch (e) {
      errorMessage.value = 'Verification failed. Please try again.';
      GlobalToast.showError(message: errorMessage.value);
      debugPrint('OTP Verification Error: $e');
    } finally {
      isLoading.value = false;
      otpFieldKey.currentState?.clearOtp();
      otp.value = '';
      update();
    }
  }

  // Resend OTP
  Future<void> resendOtp() async {
    if (!canResend.value) return;
    GlobalLoader.show();
    try {
      startResendTimer();
      // Clear any existing error
      errorMessage.value = '';

      // Simulate API call for resending OTP
      await Future.delayed(const Duration(seconds: 1));

      // Mock resend logic - replace with actual API call
      await loginController.onLoginPressed();
    } catch (e) {
      errorMessage.value =
          'Failed to resend code. Please check your connection.';
      debugPrint('Resend OTP Error: $e');
    } finally {
      GlobalLoader.hide();
    }
  }

  // Clear error message
  void clearError() {
    errorMessage.value = '';
  }

  // Format timer display
  String get formattedTimer {
    int minutes = resendTimer.value ~/ 60;
    int seconds = resendTimer.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
