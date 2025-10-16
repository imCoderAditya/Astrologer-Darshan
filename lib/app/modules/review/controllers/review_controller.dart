import 'dart:convert';

import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/review/review_model.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  Rxn<ReviewModel> reviewModel = Rxn<ReviewModel>();

  final astrologerId = LocalStorageService.getAstrologerId();

  Future<void> fetchReview() async {
    try {
      final res = await BaseClient.get(
        api:
            "${EndPoint.getConsultationReviews}?sessionId=0&customerId=0&astrologerId=$astrologerId",
      );
      if (res != null && res.statusCode == 200) {
        reviewModel.value = reviewModelFromJson(json.encode(res.data));
        LoggerUtils.debug("Response: ${json.encode(reviewModel.value)}");
      } else {
        LoggerUtils.error("Failed: ${res?.data}");
      }
    } catch (e) {
      LoggerUtils.error("Error : $e");
    } finally {
      update();
    }
  }

  @override
  void onInit() {
    fetchReview();
    super.onInit();
  }
}
