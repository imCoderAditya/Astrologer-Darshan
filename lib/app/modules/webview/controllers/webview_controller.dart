
import 'package:get/get.dart';

// Controller
class WebViewController extends GetxController {
  var progress = 0.0.obs;
  var currentUrl = ''.obs;
  var webNotLoadError = ''.obs;

  void updateProgress(double value) {
    progress.value = value;
  }

  void updateUrl(String url) {
    currentUrl.value = url;
  }

  void setError(String error) {
    webNotLoadError.value = error;
  }

  void clearError() {
    webNotLoadError.value = '';
  }
}