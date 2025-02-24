import 'package:firebase_project/utility/global_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String text;
  final double fontSize;

  final Color textColor;
  final Color elevatedColor;
  final double elevatedWidth;
  final double elevatedHeight;
  final VoidCallback onPressedCall;
  final BorderRadiusGeometry? elevatedBorderRadius;
  final Color? borderColor;

  const ElevatedButtonWidget({
    super.key,
    required this.text,
    required this.fontSize,
    required this.textColor,
    required this.elevatedColor,
    required this.elevatedWidth,
    required this.elevatedHeight,
    required this.onPressedCall,
    this.elevatedBorderRadius,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: elevatedWidth.w,
      height: elevatedHeight.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: elevatedColor,
          shape: RoundedRectangleBorder(
            borderRadius: elevatedBorderRadius ?? BorderRadius.circular(7.0).r,
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 2.0)
                : BorderSide.none,
          ),
          elevation: 0,
        ),
        onPressed: onPressedCall,
        child: Text(
          text,
          style: GlobalUtils.googleFontsFunction(
              fontSizeText: fontSize.sp, colorText: textColor),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
