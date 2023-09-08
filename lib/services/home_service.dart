import 'package:dio/dio.dart';

import '../app.dart';
import '../model/api_return/api_return.dart';
import '../model/home/home_dropdown/home_model.dart';
import '../model/home/home_filtered/histogram_model.dart';
import '../model/home/home_filtered/home_filtered_model.dart';
import '../model/home/inflasi_pertumbuhan_model.dart';
import '../model/home/sub_komoditas_model.dart';
import 'handler_service/handler_service.dart';

class HomeService {
  final Dio _dio = App.dio;

  Future<ApiReturn<HomeModel>> getDropdown() async {
    try {
      Response response = await _dio.get("config");
      if (response.statusCode == 200) {
        return ApiReturn.success(HomeModel.fromJson(response.data['data']));
      } else {
        return ApiReturn.fail(response.data['message']);
      }
    } on DioError catch (e) {
      return await HandlerService.handlerOnDioEror(e);
    } catch (e) {
      return ApiReturn.error("Erorr is happening, keep calm", 700);
    }
  }

  Future<ApiReturn<List<SubKomoditasModel>>> getDropdownSubKomoditas(String id) async {
    try {
      Response response = await _dio.get("homepage/sub/$id");
      if (response.statusCode == 200) {
        return ApiReturn.success(List.generate(
            response.data['data']?.length ?? 0,
            (index) =>
                SubKomoditasModel.fromJson(response.data['data'][index])));
      } else {
        return ApiReturn.fail(response.data['message']);
      }
    } on DioError catch (e) {
      return await HandlerService.handlerOnDioEror(e);
    } catch (e) {
      return ApiReturn.error("Erorr is happening, keep calm", 700);
    }
  }

  Future<ApiReturn<List<HomeFilteredModel>>> getHomeFiltered({
    required String subKomoditasId,
    required String pasar,
    required String kota,
    required String opsi,
    required String tanggal,
  }) async {
    try {
      Response response = await _dio.post("homepage/index", data: {
        "subkomoditas": subKomoditasId,
        "pasar": pasar,
        "kota": kota,
        "opsi": opsi,
        "tanggal": tanggal
      });
      if (response.statusCode == 200) {
        return ApiReturn.success(List.generate(
            response.data['data']?.length ?? 0,
            (index) =>
                HomeFilteredModel.fromJson(response.data['data'][index])));
      } else {
        return ApiReturn.fail(response.statusCode.toString());
      }
    } on DioError catch (e) {
      return await HandlerService.handlerOnDioEror(e);
    } catch (e) {
      return ApiReturn.error("Erorr is happening, keep calm", 700);
    }
  }

  Future<ApiReturn<List<HistogramModel>>> getHomeHistogram({
    required String subKomoditasId,
    required String pasar,
    required String tanggal,
    required String opsi,
    
  }) async {
    try {
      Response response = await _dio.post("homepage/histogram", data: {
        "subkomoditas_id": subKomoditasId,
        "pasar_id": pasar,
        "tanggal": tanggal,
        "opsi": opsi,

      });
      if (response.statusCode == 200) {
        return ApiReturn.success(List.generate(
            response.data['data']?.length ?? 0,
            (index) => HistogramModel.fromJson(response.data['data'][index])));
      } else {
        return ApiReturn.fail(response.statusCode.toString());
      }
    } on DioError catch (e) {
      return await HandlerService.handlerOnDioEror(e);
    } catch (e) {
      return ApiReturn.error("Erorr is happening, keep calm", 700);
    }
  }

  Future<ApiReturn<InflasiPertumbuhanModel>> getInflasiPertumbuhan() async {
    try {
      Response response = await _dio.get(
        "homepage/in-pe",
      );
      if (response.statusCode == 200) {
        return ApiReturn.success(
            InflasiPertumbuhanModel.fromJson(response.data['data']));
      } else {
        return ApiReturn.fail(response.statusCode.toString());
      }
    } on DioError catch (e) {
      return await HandlerService.handlerOnDioEror(e);
    } catch (e) {
      return ApiReturn.error("Erorr is happening, keep calm", 700);
    }
  }

  Future<ApiReturn> getAverage({
    required String subKomoditasId,
    required String pasar,
    required String tanggal,
  }) async {
    try {
      Response response = await _dio.post("ratarata", data: {
        "subkomoditas_id": subKomoditasId,
        "pasar_id": pasar,
        "tanggal": tanggal,
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

  Future<ApiReturn> getStdDev({
    required String subKomoditasId,
    required String pasar,
    required String tanggal,
  }) async {
    try {
      Response response = await _dio.post("stdev", data: {
        "subkomoditas": subKomoditasId,
        "jenispasar": pasar,
        "tanggal": tanggal,
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
