import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'app.dart';
import 'main_app.dart';
import 'utils/app_constant.dart';
import 'utils/core/constant_url_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  App.configure(
      apiBaseURL: ConstantUrlHelper.SERVER_ADDRESS_PROD,
      appTitle: AppConstant.APP_NAME_DEV,
      locale: 'id_ID',
      isDebug: false);

  await App().init();
  await FlutterDownloader.initialize(
      debug: false // optional: set false to disable printing logs to console
      );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MainApp());
  });
}
