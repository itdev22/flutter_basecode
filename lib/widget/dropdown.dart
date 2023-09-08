import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_lapalapa/utils/app_color.dart';

// ignore: must_be_immutable
class DropDown extends StatefulWidget {
  final List<DropdownMenuItem<String>> items;
  final void Function(String?)? onChanged;
  final String? value;
  final Widget? disabledHint;
  final String hint;
  final Color? colorEnabledBorder;
  Widget? icon;
  final bool validate;
  final double? fontSize;
  final Color? fontColor;
  final Color? hintColor;

  DropDown(
      {Key? key,
      required this.items,
      required this.onChanged,
      this.value,
      this.hint = '',
      this.icon,
      this.disabledHint,
      this.colorEnabledBorder,
      this.validate = true,
      this.fontSize,
      this.fontColor,
      this.hintColor})
      : super(key: key);

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(10.r),
          color: widget.onChanged == null ? AppColor.grey : Colors.white),
      child: DropdownButtonFormField(
          key: widget.key,
          isExpanded: true,
          style: TextStyle(
              fontSize: widget.fontSize ?? 12.sp,
              color: widget.fontColor ?? AppColor.primary,
              overflow: TextOverflow.ellipsis),
          disabledHint: widget.disabledHint,
          // iconDisabledColor: AppColor.GreyPrimary,
          items: widget.items,
          onChanged: widget.onChanged,
          hint: Text(
            widget.hint,
            style: TextStyle(
              fontSize: widget.fontSize ?? 12.sp,
              color: widget.hintColor ?? AppColor.primary,
            ),
          ),
          validator: (value) {
            if (widget.validate) {
              if (value == null) {
                return "";
              }
            }
            return null;
          },
          icon: widget.icon ??
              SvgPicture.asset(
                'assets/icons/ic_arrow_down.svg',
                fit: BoxFit.scaleDown,
              ),
          value: widget.value,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
            errorStyle: const TextStyle(
              height: 0,
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.colorEnabledBorder ?? AppColor.primary,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10.r)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColor.primary,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10.r)),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.red,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10.r),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.red, width: 1.0),
              borderRadius: BorderRadius.circular(10),
            ),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColor.primary,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10.r)),
          )),
    );
  }
}
