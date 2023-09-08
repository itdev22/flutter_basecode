import 'package:dio/dio.dart';

import '../app.dart';
import '../model/api_return/api_return.dart';
import 'handler_service/handler_service.dart';

class SuggestionService {
  final Dio _dio = App.dio;

  Future<ApiReturn> sendSuggestion({
    required String kotaId,
    required String nama,
    required String kritik,
    required String saran,
  }) async {
    try {
      Response response = await _dio.post("kritiksaran", data: {
        'kota_id': kotaId,
        'nama': nama,
        'kritik': kritik,
        'saran': saran,
      });
      if (response.statusCode == 200) {
        return ApiReturn.success(response.data['data']);
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
