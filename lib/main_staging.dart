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
      apiBaseURL: ConstantUrlHelper.SERVER_ADDRESS_STAG,
      appTitle: AppConstant.APP_NAME_STAG,
      isDebug: true,
      locale: 'id_ID');

  await App().init();
  await FlutterDownloader.initialize(
      debug: true 
      );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MainApp());
  });
}
