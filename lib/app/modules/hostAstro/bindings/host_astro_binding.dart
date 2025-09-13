import 'package:get/get.dart';

import '../controllers/host_astro_controller.dart';

class HostAstroBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HostController>(
      () => HostController(),
    );
  }
}
