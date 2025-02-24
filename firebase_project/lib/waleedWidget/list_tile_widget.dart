import 'package:firebase_project/utility/global_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ListTileWidget extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final Widget? titleWidget;
  final Widget? leadingWidget;
  final Widget? trailingWidget;
  final String? svgPath;
  final double? svgHeight;
  final double? svgWidth;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? contentPadding;
  final Function()? onTap;
  final Widget? subtitleWidget;

  const ListTileWidget({
    super.key,
    this.text,
    this.onTap,
    this.leadingWidget,
    this.trailingWidget,
    this.svgPath,
    this.svgHeight,
    this.svgWidth,
    this.icon,
    this.textStyle,
    this.contentPadding,
    this.titleWidget,
    this.subtitleWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: contentPadding,
      leading: leadingWidget ??
          (svgPath != null
              ? SvgPicture.asset(
                  svgPath!,
                  height: svgHeight!.h,
                  width: svgWidth!.w,
                )
              : null),
      title: titleWidget ??
          Text(text!,
              style: textStyle ??
                  GlobalUtils.googleFontsFunction(
                      fontWeightText: FontWeight.bold)),
      trailing: trailingWidget ?? (icon != null ? Icon(icon) : null),
      onTap: onTap,
      subtitle: subtitleWidget,
    );
  }
}
