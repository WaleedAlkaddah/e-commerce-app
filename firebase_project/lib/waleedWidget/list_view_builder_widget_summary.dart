import 'package:firebase_project/utility/global_utils.dart';
import 'package:firebase_project/waleedWidget/cached_network_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductListViewWidget extends StatelessWidget {
  final List<dynamic> products;

  const ProductListViewWidget({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return products.isEmpty
        ? Center(
            child: CircularProgressIndicator(
              color: const Color(0xff00C569),
            ),
          )
        : SizedBox(
            height: 250.0.h,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  color: Colors.white,
                  elevation: 5.0,
                  margin: EdgeInsets.all(12.0).w.h,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15).r,
                  ),
                  shadowColor: Colors.black.withValues(alpha: 0.3),
                  child: SizedBox(
                    width: 160.0.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15).r,
                            child: CachedNetworkWidget(
                              imageUrl: product["image"],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: 10.0.h, bottom: 10.0.h),
                                child: Text(
                                  product["name"],
                                  style: GlobalUtils.googleFontsFunction(
                                      fontWeightText: FontWeight.bold,
                                      fontSizeText: 16.0.sp,
                                      colorText: Colors.black),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 15.0.h),
                                child: Text(
                                  "\$${product["price"].toStringAsFixed(2)}",
                                  style: GlobalUtils.googleFontsFunction(
                                      fontWeightText: FontWeight.bold,
                                      fontSizeText: 14.0.sp,
                                      colorText: Color(0xff00C569)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
}
