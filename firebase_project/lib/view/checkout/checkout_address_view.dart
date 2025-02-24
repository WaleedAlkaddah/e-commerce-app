import 'package:firebase_project/utility/cart_utils.dart';
import 'package:firebase_project/waleedWidget/text_form_filed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutAddressView extends StatefulWidget {
  const CheckoutAddressView({super.key});

  @override
  State<CheckoutAddressView> createState() => _CheckoutAddressViewState();
}

class _CheckoutAddressViewState extends State<CheckoutAddressView> {
  final CheckoutUtils checkoutUtils = CheckoutUtils();
  @override
  void initState() {
    checkoutUtils.getUserAddress(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            30.0.verticalSpace,
            TextFormFiledWidget(
              widthFiled: 312.0,
              heightFiled: 70.0,
              labelFiled: 'Street',
              widthLabel: 33.0,
              heightLabel: 19.0,
              labelSizeFont: 14.0,
              controller: checkoutUtils.streetController,
              textInputType: TextInputType.text,
              readOnlyFiled: true,
            ),
            30.0.verticalSpace,
            TextFormFiledWidget(
              widthFiled: 312.0,
              heightFiled: 70.0,
              labelFiled: 'Country',
              widthLabel: 33.0,
              heightLabel: 19.0,
              labelSizeFont: 14.0,
              controller: checkoutUtils.countryController,
              textInputType: TextInputType.text,
              readOnlyFiled: true,
            ),
            35.0.verticalSpace,
            TextFormFiledWidget(
              widthFiled: 312.0,
              heightFiled: 70.0,
              labelFiled: 'City',
              widthLabel: 33.0,
              heightLabel: 19.0,
              labelSizeFont: 14.0,
              controller: checkoutUtils.cityController,
              textInputType: TextInputType.text,
              readOnlyFiled: true,
            ),
          ],
        ),
      ),
    );
  }
}
