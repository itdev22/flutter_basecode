import 'package:dio/dio.dart';

import '../../model/api_return/api_return.dart';
import '../../utils/core/network_info.dart';

class HandlerService {
  static Future<ApiReturn<T>> handlerOnDioEror<T>(DioError e) async {
    try {
      if (e.type == DioErrorType.connectTimeout) {
        return ApiReturn.fail("connection time out");
      } else if (e.type == DioErrorType.receiveTimeout) {
        return ApiReturn.fail("connection receive time out");
      } else if (e.type == DioErrorType.other) {
        throw await NetworkInfo.checkUserConnection();
      }
    } on NetworkInfo catch (e) {
      return ApiReturn.networkError(e.message.toString());
    }

    if (e.response!.statusCode != 200) {
      return ApiReturn.error(
          "Erorr is happening, keep calm", e.response?.statusCode);
    }
    return ApiReturn.error(
        "Erorr is happening, keep calm", e.response?.statusCode);
  }
}
