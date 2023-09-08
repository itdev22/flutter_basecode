import 'package:dio/dio.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/app_interceptor.dart';
import 'utils/core/global_method_helper.dart';
import 'utils/core/logging_interceptor.dart';

class App {
  static App? _instance;
  final String? apiBaseURL;
  final String? appTitle;
  final String? locale;
  final bool? isDebug;
  late SharedPreferences prefs;
  static late Dio dio;

  App.configure(
      {required this.apiBaseURL,
      required this.appTitle,
      required this.locale,
      required this.isDebug}) {
    _instance = this;
  }

  factory App() {
    if (_instance == null) {
      throw UnimplementedError("App must be configured first.");
    }

    return _instance!;
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();

    GlobalMethodHelper.locale = locale!;
    initializeDateFormatting(locale);

    dio = Dio(BaseOptions(
        baseUrl: apiBaseURL!,
        connectTimeout: 30000,
        receiveTimeout: 50000,
        responseType: ResponseType.json));

    dio.interceptors.add(AppInterceptor());

    if (isDebug == true) {
      dio.interceptors.add(LoggingInterceptor());
    }
  }
}
