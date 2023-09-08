import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/assets_helper.dart';
import 'button.dart';

class ErrorHandler extends StatelessWidget {
  final VoidCallback refresh;
  const ErrorHandler({
    Key? key,
    required this.refresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Column(
        children: [
          SvgPicture.asset(
            Assets.icErrorHandler,
            fit: BoxFit.scaleDown,
          ),
          SizedBox(height: 16.h),
          Text("Gagal muat",
              style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 40.h),
          Button(
            onPressed: refresh,
            text: "Muat Ulang", 
            hPadding: 54.w,
            vPadding: 16.h,
          )
        ],
      ),
    );
  }
}
