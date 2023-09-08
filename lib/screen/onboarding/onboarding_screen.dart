import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app.dart';
import '../../utils/app_color.dart';
import '../../utils/app_route.dart';
import '../../utils/assets_helper.dart';
import '../../widget/button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.imgOnboarding),
            SizedBox(height: 24.h),
            Text("Pusat Informasi Tentang Harga pangan !",
                style: TextStyle(
                    fontSize: 24.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w600)),
            SizedBox(height: 12.h),
            Text(
                "Pusat informasi resmi tentang harga pangan secara akurat dan terpercaya khusus daerah Provinsi Sulawesi Tenggara",
                style: TextStyle(fontSize: 16.sp, color: AppColor.textGrey)),
            SizedBox(height: 56.h),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Button(
                  onPressed: () async {
                    final app = App();
                    app.prefs = await SharedPreferences.getInstance();
                    app.prefs.setBool("isFirstTimeOpened", true);
                    Navigator.pushReplacementNamed(context, Routes.mainScreen);
                  },
                  text: "Cek Harga Pangan",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
