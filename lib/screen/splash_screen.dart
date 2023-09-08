import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app.dart';
import '../utils/app_color.dart';
import '../utils/app_route.dart';
import '../utils/assets_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _isFirstTime();
  }

  _isFirstTime() async {
    final app = App();
    app.prefs = await SharedPreferences.getInstance();
    var prefs = app.prefs.getBool("isFirstTimeOpened");

    if (prefs == null) {
      Future.delayed(const Duration(milliseconds: 1200), () {
        Navigator.pushReplacementNamed(context, Routes.onBoarding);
      });
    } else {
      Future.delayed(const Duration(milliseconds: 1200), () {
        Navigator.pushReplacementNamed(context, Routes.mainScreen);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Center(child: SvgPicture.asset(Assets.icSplash)),
    );
  }
}
