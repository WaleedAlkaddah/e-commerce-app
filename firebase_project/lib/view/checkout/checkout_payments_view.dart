import 'package:firebase_project/utility/cart_utils.dart';
import 'package:firebase_project/waleedWidget/text_form_filed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quick_log/quick_log.dart';

class CheckoutPaymentsView extends StatefulWidget {
  const CheckoutPaymentsView({super.key});

  @override
  State<CheckoutPaymentsView> createState() => _CheckoutPaymentsViewState();
}

class _CheckoutPaymentsViewState extends State<CheckoutPaymentsView> {
  final CheckoutUtils checkoutUtils = CheckoutUtils();
  final log = const Logger('CheckoutPaymentsView');

  @override
  void initState() {
    checkoutUtils.getUserCreditCard(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            40.0.verticalSpace,
            TextFormFiledWidget(
              widthFiled: 312.0,
              heightFiled: 70.0,
              labelFiled: 'Name on Card',
              widthLabel: 33.0,
              heightLabel: 19.0,
              labelSizeFont: 14.0,
              controller: checkoutUtils.cardHolderNameController,
              textInputType: TextInputType.text,
              readOnlyFiled: true,
            ),
            38.0.verticalSpace,
            TextFormFiledWidget(
              widthFiled: 312.0,
              heightFiled: 70.0,
              labelFiled: 'Card Number',
              widthLabel: 33.0,
              heightLabel: 19.0,
              labelSizeFont: 14.0,
              controller: checkoutUtils.cardNumberController,
              textInputType: TextInputType.text,
              readOnlyFiled: true,
            ),
            38.0.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextFormFiledWidget(
                  widthFiled: 140.0,
                  heightFiled: 70.0,
                  labelFiled: 'Expiry Date',
                  widthLabel: 33.0,
                  heightLabel: 19.0,
                  labelSizeFont: 14.0,
                  controller: checkoutUtils.expiryDateController,
                  textInputType: TextInputType.text,
                  readOnlyFiled: true,
                ),
                TextFormFiledWidget(
                  widthFiled: 135.0,
                  heightFiled: 70.0,
                  labelFiled: 'CVV',
                  widthLabel: 33.0,
                  heightLabel: 19.0,
                  labelSizeFont: 14.0,
                  controller: checkoutUtils.cvvCodeController,
                  textInputType: TextInputType.text,
                  readOnlyFiled: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
