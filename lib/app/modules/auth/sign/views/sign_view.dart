import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/sign_controller.dart';

class SignView extends GetView<SignController> {
  const SignView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SignView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
