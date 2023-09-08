import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_lapalapa/utils/app_color.dart';

class Input extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final bool passwordField;
  final bool disabled;
  final InputDecoration? decoration;
  final TextInputType keyboardType;
  final Widget? suffixWidget;
  final Widget? prefixWidget;
  final VoidCallback? onClick;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final TextCapitalization? textCapitalization;
  final double borderRadius;
  final EdgeInsets? padding;
  final double? hintFontSize;
  final FontWeight? hintFontWeight;
  final FormFieldValidator<String>? validator;
  final Color? textColor;
  final bool? obscureText;
  final double? labelFontSize;
  final FontWeight? labelFontWeight;
  final Color? labelColor;

  const Input(
      {Key? key,
      required this.controller,
      this.label,
      this.passwordField = false,
      this.disabled = false,
      this.decoration,
      this.onClick,
      this.keyboardType = TextInputType.text,
      this.suffixWidget,
      this.prefixWidget,
      this.maxLines,
      this.textCapitalization,
      this.borderRadius = 10,
      this.padding,
      this.hintFontSize,
      this.hintFontWeight,
      this.validator,
      this.onChanged,
      this.textColor,
      this.obscureText,
      this.hint,
      this.labelFontSize,
      this.labelFontWeight,
      this.labelColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (onClick != null) {
      return Stack(
        children: [
          _buildTextFormField(context),
          SizedBox(
            height: 40.h,
            width: double.infinity,
            child: GestureDetector(
              onTap: onClick,
            ),
          )
        ],
      );
    } else {
      return _buildTextFormField(context);
    }
  }

  Widget _buildTextFormField(context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: maxLines != null ? TextInputType.multiline : keyboardType,
      maxLines: maxLines,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      readOnly: _isDisabled(),
      validator: validator,
      cursorColor: Colors.black,
      obscureText: obscureText ?? false,
      style: TextStyle(
          fontWeight: hintFontWeight ?? FontWeight.w400,
          fontSize: hintFontSize ?? 15.sp,
          color: textColor ?? Colors.black),
      decoration: decoration ??
          InputDecoration(
            labelStyle: TextStyle(
                fontWeight: labelFontWeight ?? FontWeight.w400,
                fontSize: labelFontSize ?? 15.sp,
                color: labelColor ?? Colors.black),
            labelText: label,
            floatingLabelStyle: TextStyle(color: AppColor.red, fontSize: 12.sp),
            filled: true,
            hintText: hint,
            hintStyle: TextStyle(
                fontWeight: hintFontWeight ?? FontWeight.w400,
                fontSize: hintFontSize ?? 15.sp,
                color: AppColor.textGrey),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(width: 1.w, color: AppColor.primary)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(width: 1.w, color: AppColor.primary)),
            contentPadding: padding ??
                EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            fillColor: Colors.white,
            focusColor: Colors.white,
            prefixIcon: prefixWidget,
            suffixIcon: suffixWidget,
            errorStyle: const TextStyle(height: 0),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(width: 1.w, color: AppColor.red)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(width: 1.w, color: AppColor.red)),
          ),
    );
  }

  bool _isDisabled() {
    if (onClick != null) {
      return true;
    }

    return disabled;
  }
}
