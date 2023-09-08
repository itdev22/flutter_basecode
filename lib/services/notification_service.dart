import 'package:dio/dio.dart';
import 'package:mobile_lapalapa/model/notification/notification_model.dart';

import '../app.dart';
import '../model/api_return/api_return.dart';
import 'handler_service/handler_service.dart';

class NotificationService {
  final Dio _dio = App.dio;

  Future<ApiReturn<NotificationModel>> getNotification() async {
    try {
      Response response = await _dio.get("notifikasi");
      if (response.statusCode == 200) {
        return ApiReturn.success(
            NotificationModel.fromJson(response.data['data']));
      } else {
        return ApiReturn.fail(response.statusCode.toString());
      }
    } on DioError catch (e) {
      return await HandlerService.handlerOnDioEror(e);
    } catch (e) {
      return ApiReturn.error("Erorr is happening, keep calm", 700);
    }
  }
}
