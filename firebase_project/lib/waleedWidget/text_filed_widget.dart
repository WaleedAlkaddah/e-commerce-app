import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFiledWidget extends StatelessWidget {
  final TextEditingController widgetController;
  final Color backgroundColor;
  final Color? borderColor;
  final IconData icon;
  final Color cursorColor;
  final Color prefixIconColor;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final bool enabled;
  final TextInputAction? textInputActionWidget;
  final void Function(String)? onSubmittedFunction;

  const TextFiledWidget({
    super.key,
    required this.widgetController,
    this.backgroundColor = Colors.transparent,
    this.borderColor,
    this.icon = Icons.search_rounded,
    this.cursorColor = const Color(0xff00C569),
    this.prefixIconColor = Colors.black,
    this.hintText,
    this.hintTextStyle,
    this.enabled = true,
    this.textInputActionWidget,
    this.onSubmittedFunction,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: cursorColor,
      controller: widgetController,
      enabled: enabled,
      textInputAction: textInputActionWidget,
      onSubmitted: onSubmittedFunction,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintTextStyle,
        prefixIcon: Container(
          margin: EdgeInsets.only(left: 20.0.w, right: 10.0.w),
          child: Icon(icon),
        ),
        prefixIconColor: prefixIconColor,
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0).r,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0).r,
          borderSide: borderColor != null
              ? BorderSide(
                  color: borderColor!,
                  width: 1.0.w,
                )
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0).r,
          borderSide: borderColor != null
              ? BorderSide(
                  color: borderColor!,
                  width: 2.0.w,
                )
              : BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0).r,
            borderSide: const BorderSide(color: Colors.grey)),
        contentPadding: EdgeInsets.only(top: 12.0.h),
      ),
    );
  }
}
