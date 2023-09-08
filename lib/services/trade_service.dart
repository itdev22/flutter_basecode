import 'package:dio/dio.dart';

import '../app.dart';
import '../model/api_return/api_return.dart';
import '../model/home/trade_model/detail_trade_model.dart';
import '../model/home/trade_model/trade_model.dart';
import 'handler_service/handler_service.dart';

class TradeService {
  final Dio _dio = App.dio;

  Future<ApiReturn<List<TradeModel>>> getTrade({
    required String kotaId,
    required String pasar,
  }) async {
    try {
      Response response = await _dio.post("perdagangan/index", data: {
        "kota_id": kotaId,
        "jenispasar_id": pasar,
      });
      if (response.statusCode == 200) {
        return ApiReturn.success(List.generate(response.data['data']?.length??0,
            (index) => TradeModel.fromJson(response.data['data'][index])));
      } else {
        return ApiReturn.fail(response.statusCode.toString());
      }
    } on DioError catch (e) {
      return await HandlerService.handlerOnDioEror(e);
    } catch (e) {
      return ApiReturn.error("Erorr is happening, keep calm", 700);
    }
  }

  Future<ApiReturn<DetailTradeModel>> getDetailTrade(
      {required String id,
      required String kotaId,
      required String pasarId}) async {
    try {
      Response response = await _dio.post("perdagangan/detail", data: {
        "kota_id": kotaId,
        "jenispasar_id": pasarId,
        "subkomoditas_id": id,
      });
      if (response.statusCode == 200) {
        return ApiReturn.success(
            DetailTradeModel.fromJson(response.data['data']));
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
