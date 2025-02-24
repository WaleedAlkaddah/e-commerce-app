import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CachedNetworkWidget extends StatelessWidget {
  final String imageUrl;
  final double imageHeight;
  final double imageWidth;
  final BoxFit imageFit;
  const CachedNetworkWidget(
      {super.key,
      required this.imageUrl,
      this.imageHeight = 0.0,
      this.imageWidth = double.infinity,
      this.imageFit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(
          color: Color(0xff00C569),
        ),
      ),
      errorWidget: (context, url, error) =>
          const Center(child: Icon(Icons.error)),
      fit: imageFit,
      width: imageWidth.w,
      height: imageHeight.h,
      filterQuality: FilterQuality.high,
    );
  }
}
