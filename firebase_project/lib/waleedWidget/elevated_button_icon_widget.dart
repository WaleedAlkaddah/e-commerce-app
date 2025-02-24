import 'package:firebase_project/utility/global_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ElevatedButtonIconWidget extends StatefulWidget {
  final String text;
  final double fontSize;
  final String svgPath;
  final double svgWidth;
  final double svgHeight;
  final double? textWidth;
  final double? textHeight;
  final Color textColor;
  final Color elevatedColor;
  final double elevatedWidth;
  final double elevatedHeight;
  final double spaceBetweenIcon;
  final double spaceBetweenText;
  final VoidCallback? onPressedCall;
  final bool isEnabled;
  final Color borderColor;
  const ElevatedButtonIconWidget({
    super.key,
    required this.text,
    required this.fontSize,
    this.textWidth,
    this.textHeight,
    required this.textColor,
    required this.elevatedColor,
    required this.elevatedWidth,
    required this.elevatedHeight,
    required this.onPressedCall,
    required this.borderColor,
    required this.svgPath,
    required this.svgWidth,
    required this.svgHeight,
    this.isEnabled = true,
    required this.spaceBetweenIcon,
    required this.spaceBetweenText,
  });

  @override
  State<ElevatedButtonIconWidget> createState() =>
      _ElevatedButtonIconWidgetState();
}

class _ElevatedButtonIconWidgetState extends State<ElevatedButtonIconWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.elevatedWidth.w,
      height: widget.elevatedHeight.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.elevatedColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 2.0.r,
              color: widget.borderColor,
            ),
            borderRadius: BorderRadius.circular(7.0).r,
          ),
          elevation: 0,
        ),
        onPressed: widget.isEnabled ? widget.onPressedCall : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              widget.svgPath,
              height: widget.svgHeight.h,
              width: widget.svgWidth.w,
            ),
            widget.spaceBetweenIcon.horizontalSpace,
            Text(
              widget.text,
              style: GlobalUtils.googleFontsFunction(
                  fontSizeText: widget.fontSize.sp,
                  colorText: widget.textColor,
                  fontWeightText: FontWeight.normal),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            widget.spaceBetweenText.horizontalSpace,
          ],
        ),
      ),
    );
  }
}
