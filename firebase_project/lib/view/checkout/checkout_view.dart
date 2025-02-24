import 'package:firebase_project/utility/cart_utils.dart';
import 'package:firebase_project/utility/global_utils.dart';
import 'package:firebase_project/view/checkout/checkout_address_view.dart';
import 'package:firebase_project/view/checkout/checkout_delivery_view.dart';
import 'package:firebase_project/view/checkout/checkout_payments_view.dart';
import 'package:firebase_project/view/checkout/checkout_summary_view.dart';
import 'package:firebase_project/waleedWidget/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quick_log/quick_log.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final log = const Logger('CheckoutView');
  @override
  void initState() {
    log.info(CheckoutUtils.activeStep);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
          height: 84.0.h,
          width: 1.0.sw,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0xff707070).withValues(alpha: 0.5),
                spreadRadius: 2.0,
                blurRadius: 6.0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (CheckoutUtils.activeStep > 0)
                ElevatedButtonWidget(
                  text: "Back",
                  fontSize: 14.0,
                  textColor: Colors.black,
                  borderColor: const Color(0xff00C569),
                  elevatedColor: Colors.white,
                  elevatedWidth: 146.0,
                  elevatedHeight: 50.0,
                  onPressedCall: () {
                    if (CheckoutUtils.activeStep > 0) {
                      setState(() => CheckoutUtils.activeStep--);
                    }
                  },
                ),
              ElevatedButtonWidget(
                text: "Next",
                fontSize: 14.0,
                textColor: Colors.white,
                elevatedColor: const Color(0xff00C569),
                elevatedWidth: 146.0,
                elevatedHeight: 50.0,
                onPressedCall: () {
                  if (CheckoutUtils.activeStep < 2) {
                    setState(() => CheckoutUtils.activeStep++);
                  } else {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          child: CheckoutSummaryView()),
                    );
                  }
                },
              ),
            ],
          )),
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xff00C569)),
        ),
        centerTitle: true,
        title: Text(
          "Checkout",
          style: GlobalUtils.googleFontsFunction(
            fontSizeText: 20.0.sp,
            fontWeightText: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          EasyStepper(
            activeStep: CheckoutUtils.activeStep,
            lineStyle: const LineStyle(
              lineLength: 100.0,
              lineType: LineType.normal,
              activeLineColor: Color(0xff00C569),
              finishedLineColor: Color(0xff00C569),
              unreachedLineColor: Color(0xffDDDDDD),
            ),
            stepShape: StepShape.circle,
            activeStepBorderColor: const Color(0xff00C569),
            unreachedStepBorderColor: const Color(0xffDDDDDD),
            activeStepBorderType: BorderType.normal,
            unreachedStepBorderType: BorderType.normal,
            activeStepBackgroundColor: Colors.transparent,
            activeStepTextColor: Colors.black,
            showLoadingAnimation: true,
            finishedStepBackgroundColor: const Color(0xff00C569),
            finishedStepBorderColor: const Color(0xffDDDDDD),
            finishedStepTextColor: const Color(0xff707070),
            finishedStepBorderType: BorderType.normal,
            unreachedStepBackgroundColor: Colors.transparent,
            unreachedStepTextColor: Colors.grey,
            enableStepTapping: false,
            stepBorderRadius: 15.0.r,
            stepRadius: 15.0.r,
            borderThickness: 3.0,
            steps: CheckoutUtils.steps,
            onStepReached: (index) =>
                setState(() => CheckoutUtils.activeStep = index),
          ),
          Expanded(
            child: IndexedStack(
              index: CheckoutUtils.activeStep,
              children: const [
                CheckoutDeliveryView(),
                CheckoutAddressView(),
                CheckoutPaymentsView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
