import 'package:firebase_project/utility/global_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CategoryItemsWidget extends StatelessWidget {
  final String svgPath;
  final String label;

  const CategoryItemsWidget({
    super.key,
    required this.label,
    required this.svgPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF242424).withValues(alpha: 0.04),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 40.0.r,
            backgroundColor: Colors.white,
            child: SvgPicture.asset(
              svgPath,
              height: 40.75.h,
              width: 40.0.w,
            ),
          ),
        ),
        SizedBox(height: 13.0.h),
        Text(
          label,
          style: GlobalUtils.googleFontsFunction(
              fontSizeText: 12.0.sp, fontWeightText: FontWeight.bold),
        ),
      ],
    );
  }
}
