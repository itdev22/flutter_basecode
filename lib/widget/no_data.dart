import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/app_color.dart';
import '../utils/assets_helper.dart';

class NoData extends StatelessWidget {
  final String text;
  const NoData({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        
        children: [
          SvgPicture.asset(
            Assets.ictest,
            fit: BoxFit.scaleDown,
          ),
          SizedBox(height: 16.h),
          Text(
            text,
            style: TextStyle(fontSize: 14.sp, color: AppColor.textGrey),
          )
        ],
      ),
    );
  }
}
