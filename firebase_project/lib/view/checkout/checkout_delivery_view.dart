import 'package:firebase_project/utility/cart_utils.dart';
import 'package:firebase_project/utility/global_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutDeliveryView extends StatefulWidget {
  const CheckoutDeliveryView({super.key});

  @override
  State<CheckoutDeliveryView> createState() => _CheckoutDeliveryViewState();
}

class _CheckoutDeliveryViewState extends State<CheckoutDeliveryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 16.0.w),
              child: Text(
                "Standard Delivery",
                style: GlobalUtils.googleFontsFunction(
                    fontWeightText: FontWeight.bold,
                    fontSizeText: 18.0.sp,
                    colorText: Colors.black),
              ),
            ),
            19.0.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 16.0.w, right: 34.0.w),
                    child: Text(
                      "Order will be delivered between 3 - 5 business days.",
                      style: GlobalUtils.googleFontsFunction(
                          fontSizeText: 14.0.sp, colorText: Colors.black),
                      maxLines: 2,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 14.0.w),
                  child: Checkbox(
                    activeColor: const Color(0xff00C569),
                    value: CheckoutUtils.isChecked,
                    onChanged: (value) {
                      setState(() {
                        CheckoutUtils.isChecked = value ?? false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
