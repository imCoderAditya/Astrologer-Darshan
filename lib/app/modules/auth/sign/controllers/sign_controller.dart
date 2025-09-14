import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_form_field/phone_form_field.dart';

class SignController extends GetxController {
  // Text controllers
  final phoneController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final placeOfBirthController = TextEditingController();

  // Observable values
  final phoneNumber = Rx<PhoneNumber?>(null);
  final selectedImage = Rx<File?>(null);
  final dateOfBirth = Rx<DateTime?>(null);
  final timeOfBirth = Rx<TimeOfDay?>(null);
  final selectedGender = 'Male'.obs;
  final isLoading = false.obs;

  File? file;

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
    }
  }

  Future<void> registerAstrologer() async {}
}
