import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';

abstract class UserRequestRepository {
  Future<dynamic> fetchUserRequest();
}

class UserRequestReposites extends UserRequestRepository {
  final userId = LocalStorageService.getUserId();
  @override
  Future<dynamic> fetchUserRequest({String? status,String? sessionType}) async {
    try {
      final res = await BaseClient.post(
        api: EndPoint.getConsultationSessions,
        payloadObj: {
          "AstrologerId": int.parse(userId.toString()),
          "CustomerId": 0,
          "SessionType":sessionType,
          "Status": status ?? "",
          "Page": 1,
          "Limit": 1000,
        },
      );

      if (res != null && res.statusCode == 200) {
        return res;
      } else {
        return null;
      }
    } catch (e) {
      LoggerUtils.error("Error: $e");
      return null;
    }
  }
}
