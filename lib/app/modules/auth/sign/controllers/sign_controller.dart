import 'dart:io';
import 'package:astrology/app/core/utils/date_utils.dart';
import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/routes/app_pages.dart';
import 'package:astrology/app/services/firebase/firebase_services.dart';
import 'package:astrology/components/snack_bar_view.dart';
import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class SignController extends GetxController {
  // Text controllers
  final phoneController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final placeOfBirthController = TextEditingController();
  final bioController = TextEditingController();
  final otpController = TextEditingController();

  final selectedImage = Rx<File?>(null);
  final dateOfBirth = Rx<DateTime?>(null);
  final timeOfBirth = Rx<TimeOfDay?>(null);
  final selectedGender = 'Male'.obs;
  final isLoading = false.obs;
  String? fmcToken;
  File? file;
  @override
  void onInit() {
    phoneController.text = Get.arguments["phoneNumber"];
    getToken();
    super.onInit();
  }

  void getToken() async {
    fmcToken = await FirebaseServices.firebaseToken();
  }

  Future<void> pickImage({required ImageSource sourc}) async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(source: sourc);
    if (pickedFile != null) {
      file = File(pickedFile.path);
      debugPrint("Image picked: ${file!.path}");
      selectedImage.value = file;
    } else {
      debugPrint("No image selected.");
    }
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dateOfBirth.value = picked;
    }
  }

  void selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      timeOfBirth.value = picked;
      debugPrint(
        "Birth Time : ${timeOfBirth.value?.hour}:${timeOfBirth.value?.minute}",
      );
    }
  }

  Future<void> registerAstrologer() async {
    isLoading.value = true;
    try {
      final dateOfBirthStr = AppDateUtils.formatToYMD(dateOfBirth.value);
      final timeOfBirthStr =
          "${timeOfBirth.value?.hour}:${timeOfBirth.value?.minute}";
      FormData formData = FormData.fromMap({
        "PhoneNumber": phoneController.text,
        "Otp": otpController.text,
        "Fcm": fmcToken.toString(),
        "FirstName": firstNameController.text,
        "LastName": lastNameController.text,
        "Email": emailController.text,
        "DateOfBirth": dateOfBirthStr.toString(),
        "PasswordHash": "", // ✅ match what your backend expects (or hash)
        "PlaceOfBirth": placeOfBirthController.text,
        "TimeOfBirth": timeOfBirthStr.toString(),
        "Gender": selectedGender.value,
        "Bio": bioController.text,
        "file": await MultipartFile.fromFile(
          file!.path,
          filename: file?.path.split('/').last,
        ),
      });

      final res = await BaseClient.post(
        api: EndPoint.registerAstrologer,
        formData: formData,
      );

      if (res != null && res.statusCode == 201) {
        LoggerUtils.error("Register :- ${res.data}");
        final userId = res.data["userId"].toString();
        final astrologerId = res.data["astrologerId"];
        // LocalStorageService.saveLogin(
        //   userId: userId,
        //   userAstrologerId: astrologerId,
        // );
        Get.offNamed(Routes.LOGIN);
        debugPrint("UserId ===>$userId");
        debugPrint("UserId ===>$astrologerId");
      } else {
        SnackBarUiView.showError(message: res.data["message"]);
        LoggerUtils.error("Failed Register :- ${res.data}");
      }
    } catch (e) {
      SnackBarUiView.showError(message: "Something went wrong");
      LoggerUtils.error("Error: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void validation() {
    if (file == null) {
      SnackBarUiView.showError(message: "Please select a profile picture");
    } else if (firstNameController.text.isEmpty) {
      SnackBarUiView.showError(message: "Please enter your first name");
    } else if (lastNameController.text.isEmpty) {
      SnackBarUiView.showError(message: "Please enter your last name");
    } else if (emailController.text.isEmpty) {
      SnackBarUiView.showError(message: "Please enter your email");
    } else if (!GetUtils.isEmail(emailController.text)) {
      SnackBarUiView.showError(message: "Please enter a valid email address");
    } else if (phoneController.text.isEmpty) {
      SnackBarUiView.showError(message: "Please enter your phone number");
    } else if (!GetUtils.isPhoneNumber(phoneController.text)) {
      SnackBarUiView.showError(message: "Please enter a valid phone number");
    } else if (otpController.text.isEmpty) {
      SnackBarUiView.showError(message: "Please enter the OTP");
    } else if (otpController.text.length < 6) {
      SnackBarUiView.showError(message: "OTP must be 6 digits");
    } else if (dateOfBirth.value == null) {
      SnackBarUiView.showError(message: "Please select your date of birth");
    } else if (timeOfBirth.value == null) {
      SnackBarUiView.showError(message: "Please select your time of birth");
    } else if (placeOfBirthController.text.isEmpty) {
      SnackBarUiView.showError(message: "Please enter your place of birth");
    } else if (bioController.text.isEmpty) {
      SnackBarUiView.showError(message: "Please enter your bio");
    } else if (selectedGender.value.isEmpty) {
      SnackBarUiView.showError(message: "Please select your gender");
    } else {
      registerAstrologer(); // All validations passed
    }
  }
}
