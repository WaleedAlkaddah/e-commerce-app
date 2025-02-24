import 'package:firebase_project/utility/global_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'cached_network_widget.dart';

class GridViewBuilderWidget extends StatelessWidget {
  final List<dynamic> dataList;
  final Function(int) onTapCall;

  const GridViewBuilderWidget({
    super.key,
    required this.dataList,
    required this.onTapCall,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 4,
        childAspectRatio: 0.6,
      ),
      itemCount: dataList.length,
      itemBuilder: (BuildContext context, int index) {
        final shoe = dataList[index];
        return Card(
          color: Colors.white,
          elevation: 5.0,
          margin: EdgeInsets.only(left: 10.0.w, top: 7.0.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10).r,
          ),
          child: InkWell(
            onTap: () => onTapCall(index),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkWidget(
                      imageUrl: shoe.image,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0.h, left: 10.0.w),
                  child: Text(
                    shoe.name,
                    style: GlobalUtils.googleFontsFunction(
                        fontSizeText: 16.0.sp, fontWeightText: FontWeight.bold),
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: 5.0.h, bottom: 10.0.h, left: 12.0.w),
                  child: Text(
                    shoe.brand,
                    style: TextStyle(
                      fontFamily: "SF Pro Display",
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 12.0.sp,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15.0.h, left: 10.0.w),
                  child: Text(
                    '\$${shoe.price.toStringAsFixed(1)}',
                    style: TextStyle(
                      fontFamily: "SF Pro Display",
                      color: const Color(0xff00C569),
                      fontSize: 16.0.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
