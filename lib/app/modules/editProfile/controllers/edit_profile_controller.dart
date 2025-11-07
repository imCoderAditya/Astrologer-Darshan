// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/models/profile/profile_model.dart';
import 'package:astrology/app/modules/profile/controllers/profile_controller.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:astrology/components/snack_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EditProfileController extends GetxController {
  Rxn<ProfileModel> profileModel = Rxn<ProfileModel>();
  // Text Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final displayNameController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final timeOfBirthController = TextEditingController();
  final placeOfBirthController = TextEditingController();
  final bioController = TextEditingController();
  final experienceController = TextEditingController();
  final specializationsController = TextEditingController();
  final languagesController = TextEditingController();
  final educationController = TextEditingController();
  final certificationsController = TextEditingController();
  final accountNumberController = TextEditingController();
  final bankNameController = TextEditingController();
  final ifscController = TextEditingController();
  final panController = TextEditingController();
  final gstController = TextEditingController();
  final passwordController = TextEditingController();
  RxString? profilePicture = "".obs;

  // Observable variables
  final selectedGender = ''.obs;
  final profileImage = Rx<File?>(null);
  final isLoading = false.obs;

  // User ID - Get from storage or pass as parameter
  String? userId =
      LocalStorageService.getUserId(); // Replace with actual user ID from storage

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    profileModel = Get.arguments;

    log("Initilize ProfileModel ===>${json.encode(profileModel.value)}");

    super.onInit();
    loadProfileData();
  }

  @override
  void onClose() {
    // Dispose all controllers
    firstNameController.dispose();
    lastNameController.dispose();
    displayNameController.dispose();
    dateOfBirthController.dispose();
    timeOfBirthController.dispose();
    placeOfBirthController.dispose();
    bioController.dispose();
    experienceController.dispose();
    specializationsController.dispose();
    languagesController.dispose();
    educationController.dispose();
    certificationsController.dispose();
    accountNumberController.dispose();
    bankNameController.dispose();
    ifscController.dispose();
    panController.dispose();
    gstController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void loadProfileData() async {
    final data = profileModel.value?.data;
    if (data != null) {
      firstNameController.text = data.firstName ?? '';
      lastNameController.text = data.lastName ?? '';
      displayNameController.text = data.displayName ?? '';
      dateOfBirthController.text = data.dateOfBirth ?? '';
      timeOfBirthController.text = data.timeOfBirth ?? '';
      placeOfBirthController.text = data.placeOfBirth ?? '';
      selectedGender.value = data.gender ?? "";
      bioController.text = data.bio ?? '';
      experienceController.text = data.experience?.toString() ?? '';
      specializationsController.text = data.specializations ?? '';
      languagesController.text = data.languages ?? '';
      educationController.text = data.education ?? '';
      certificationsController.text = data.certifications ?? '';
      profilePicture?.value = data.profilePicture ?? "";

      /// bank accountDetails & taxDetails are in a combined string
      /// you probably need to decode or parse it if API provides structured JSON
      final bankJson = jsonDecode(data.bankAccountDetails!);

      accountNumberController.text = bankJson['AccountNumber'] ?? '';
      bankNameController.text = bankJson['BankName'] ?? '';
      ifscController.text = bankJson['IFSC'] ?? '';
      panController.text = bankJson['Pan'] ?? '';
      gstController.text = bankJson['GST'] ?? '';

     
      update();
    }
  }

  // Pick image from gallery or camera
  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
      }
    } catch (e) {
      SnackBarUiView.showError(message: 'Somthing went wrong');
    }
  }

  // Select date of birth
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 365 * 25)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Color(0xFFc40294)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  // Select time of birth
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Color(0xFFc40294)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final now = DateTime.now();
      final dt = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      timeOfBirthController.text = DateFormat('HH:mm:ss').format(dt);
    }
  }

  // Validate form
  bool validateForm() {
    if (firstNameController.text.trim().isEmpty) {
      SnackBarUiView.showError(message: 'Please enter first name');

      return false;
    }

    if (lastNameController.text.trim().isEmpty) {
      SnackBarUiView.showError(message: 'Please enter last name');

      return false;
    }

    // if (dateOfBirthController.text.trim().isEmpty) {
    //   SnackBarUiView.showError(message: 'Please select date of birth');
    //   return false;
    // }

    // if (passwordController.text.trim().isEmpty) {
    //   SnackBarUiView.showError(message: 'Please enter password');

    //   return false;
    // }

    if (accountNumberController.text.trim().isNotEmpty) {
      if (bankNameController.text.trim().isEmpty ||
          ifscController.text.trim().isEmpty ||
          panController.text.trim().isEmpty) {
        SnackBarUiView.showError(message: 'Please complete all bank details');

        return false;
      }
    }

    return true;
  }

  final profileController = Get.find<ProfileController>();
  // Update profile API call
  Future<void> updateProfile() async {
    if (!validateForm()) return;

    isLoading.value = true;

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://astroapi.veteransoftwares.com/api/Registration/UpdateAstrologerProfile',
        ),
      );

      // Add form fields
      request.fields['UserID'] = userId ?? "";
      request.fields['FirstName'] = firstNameController.text.trim();
      request.fields['LastName'] = lastNameController.text.trim();
      request.fields['DateOfBirth'] = dateOfBirthController.text.trim();
      request.fields['TimeOfBirth'] =
          timeOfBirthController.text.trim().isEmpty
              ? '00:00:00'
              : timeOfBirthController.text.trim();
      request.fields['PlaceOfBirth'] = placeOfBirthController.text.trim();
      request.fields['Gender'] = selectedGender.value;
      request.fields['PasswordHash'] = passwordController.text.trim();
      request.fields['DisplayName'] =
          displayNameController.text.trim().isEmpty
              ? '${firstNameController.text} ${lastNameController.text}'
              : displayNameController.text.trim();
      request.fields['Bio'] = bioController.text.trim();
      request.fields['Experience'] =
          experienceController.text.trim().isEmpty
              ? '0'
              : experienceController.text.trim();
      request.fields['Specializations'] = specializationsController.text.trim();
      request.fields['Languages'] = languagesController.text.trim();
      request.fields['Education'] = educationController.text.trim();
      request.fields['Certifications'] = certificationsController.text.trim();

      // Bank Account Details as JSON
      if (accountNumberController.text.trim().isNotEmpty) {
        Map<String, String> bankDetails = {
          'AccountNumber': accountNumberController.text.trim(),
          'BankName': bankNameController.text.trim(),
          'IFSC': ifscController.text.trim(),
          'Pan': panController.text.trim(),
          'GST': gstController.text.trim(),
        };
        request.fields['BankAccountDetails'] = jsonEncode(bankDetails);
      }

      // Tax Details as JSON
      if (panController.text.trim().isNotEmpty) {
        Map<String, String> taxDetails = {'PAN': panController.text.trim()};
        request.fields['TaxDetails'] = jsonEncode(taxDetails);
      }

      // Add profile image if selected
      if (profileImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'ProfilePicture',
            profileImage.value!.path,
          ),
        );
      }

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        log("Edit Profile res: $jsonResponse");
        // Navigate back or refresh profile
        await Future.delayed(Duration(seconds: 1));
        Get.back(result: true); // Return true to indicate success
      } else {
        LoggerUtils.error('Please complete all bank details');
      }
    } catch (e) {
      SnackBarUiView.showError(message: 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  // Show image source selection dialog
  Future<void> showImageSourceDialog() async {
    Get.dialog(
      AlertDialog(
        title: Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: Color(0xFFc40294)),
              title: Text('Gallery'),
              onTap: () {
                Get.back();
                pickImageFromSource(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: Color(0xFFc40294)),
              title: Text('Camera'),
              onTap: () {
                Get.back();
                pickImageFromSource(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Pick image from specific source
  Future<void> pickImageFromSource(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
