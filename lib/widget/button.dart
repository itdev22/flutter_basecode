/*
Author: Rehan Arroihan
Date: 21/12/21
Purpose: reusable button with multiple theme for demokrat apps
Copyright: © 2020, Rehan Arroihan. All rights reserved.
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_lapalapa/utils/app_color.dart';
import 'package:mobile_lapalapa/utils/app_constant.dart';

enum AppButtonStyle {
  primary,
  red,

  outlinePrimary,
  outlineRed,
}

class Button extends StatelessWidget {
  final AppButtonStyle style;
  final String text;
  final bool isLoading;
  final bool isDisabled;
  final double radius;
  final VoidCallback onPressed;
  final double fontSize;
  final FontWeight fontWeight;
  final double hPadding;
  final double vPadding;
  final Alignment alignment;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double elevation;
  final double? textMaxSize;

  const Button(
      {Key? key,
      required this.onPressed,
      this.style = AppButtonStyle.primary,
      this.text = '',
      this.isLoading = false,
      this.isDisabled = false,
      this.fontSize = 16,
      this.radius = 30,
      this.fontWeight = FontWeight.w500,
      this.hPadding = 24,
      this.vPadding = 16,
      this.alignment = Alignment.center,
      this.prefixIcon,
      this.suffixIcon,
      this.elevation = 2,
      this.textMaxSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The other basic button
    return Theme(
      data: ThemeData(splashColor: Colors.red),
      child: ElevatedButton(
          onPressed: !isDisabled ? onPressed : null,
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: hPadding,vertical: vPadding)),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: MaterialStateProperty.all(
                _getButtonColorByStyle(style, isLoading)),
            elevation: MaterialStateProperty.all(elevation),
            alignment: alignment,
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius))),
            side: _getButtonBorder(style),
            overlayColor: MaterialStateProperty.resolveWith(
              (states) {
                return states.contains(MaterialState.pressed)
                    ? _getButtonRippleColor(style)
                    : null;
              },
            ),
          ),
          child: _buttonMainContentChild()),
    );
  }

  Widget _buttonMainContentChild() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        prefixIcon ?? const SizedBox(width: 0, height: 0),
        textMaxSize == null
            ? Text(
                text,
                style: TextStyle(
                    fontSize: fontSize.sp,
                    color: _getFontColorByStyle(style),
                    fontFamily: AppConstant.MAIN_FONT_NAME,
                    fontWeight: fontWeight),
              )
            : SizedBox(
                width: textMaxSize,
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: fontSize.sp,
                      color: _getFontColorByStyle(style),
                      fontFamily: AppConstant.MAIN_FONT_NAME,
                      fontWeight: fontWeight),
                ),
              ),
        suffixIcon ?? const SizedBox(width: 0, height: 0),
      ],
    );
  }

  Color _getButtonColorByStyle(AppButtonStyle style, bool isLoading) {
    Color? color;

    if (isLoading) {
      return Colors.grey.withOpacity(0.2);
    }

    switch (style) {
      case AppButtonStyle.primary:
        color = AppColor.primary;
        break;

      case AppButtonStyle.red:
        color = AppColor.red;
        break;
        
      case AppButtonStyle.outlinePrimary:
        color = Colors.white;
        break;

      case AppButtonStyle.outlineRed:
        color =Colors.white;
        break;

     
      default:
        break;
    }

    return color!;
  }

  Color _getFontColorByStyle(AppButtonStyle style) {
    Color? color;

    switch (style) {
      case AppButtonStyle.primary:
        color =Colors.white;
        break;

      case AppButtonStyle.red:
        color = Colors.white;
        break;

      case AppButtonStyle.outlinePrimary:
        color = AppColor.primary;
        break;

      case AppButtonStyle.outlineRed:
        color = AppColor.red;
        break;

      
      default:
        break;
    }

    return color!;
  }

  MaterialStateProperty<BorderSide> _getButtonBorder(AppButtonStyle style) {
    if (style == AppButtonStyle.outlineRed) {
      return MaterialStateProperty.all(
          BorderSide(width: 1, color: AppColor.primary));
    }

    if (style == AppButtonStyle.outlineRed) {
      return MaterialStateProperty.all(
          BorderSide(width: 1, color: AppColor.red));
    }

    return MaterialStateProperty.all(BorderSide.none);
  }

  Color _getButtonRippleColor(AppButtonStyle style) {
    if (style == AppButtonStyle.primary) {
      return Colors.white.withOpacity(0.2);
    }

    if (style == AppButtonStyle.red) {
      return Colors.white.withOpacity(0.2);
    }

    if (style == AppButtonStyle.outlinePrimary) {
      return AppColor.primary.withOpacity(0.2);
    }

    if (style == AppButtonStyle.outlineRed) {
      return AppColor.red.withOpacity(0.2);
    }

   
    return Colors.white.withOpacity(0.2);
  }
}
