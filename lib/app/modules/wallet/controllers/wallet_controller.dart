import 'dart:convert';

import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/wallet/wallet_model.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  int? astrologerId = LocalStorageService.getAstrologerId();
  var isLoading = false.obs;
  Rxn<WalletModel> walletModel = Rxn<WalletModel>();

  Future<void> fetchWallet() async {
    isLoading.value = true;
    try {
      final res = await BaseClient.get(
        api:
            "${EndPoint.astrologerWallet}?userId=$astrologerId&transactionType=All&status=All",
      );
      if (res != null && res.statusCode == 200) {
        walletModel.value = walletModelFromJson(json.encode(res.data));
        LoggerUtils.debug("Wallet ${json.encode(walletModel.value)}");
      } else {
        LoggerUtils.error("Failed: ${res?.data}");
      }
    } catch (e) {
      LoggerUtils.error("Error: $e");
    } finally {
      isLoading.value = false;
      update();
      
    }
  }

  @override
  void onInit() {
    fetchWallet();
    super.onInit();
  }
}
