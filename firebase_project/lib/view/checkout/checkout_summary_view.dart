import 'package:firebase_project/navigation_bar_app.dart';
import 'package:firebase_project/services/awesome_notifications_services.dart';
import 'package:firebase_project/states/checkout_states/checkout_states.dart';
import 'package:firebase_project/utility/cart_utils.dart';
import 'package:firebase_project/utility/check_internet_utils.dart';
import 'package:firebase_project/utility/global_utils.dart';
import 'package:firebase_project/utility/hive_constants.dart';
import 'package:firebase_project/utility/hive_preferences_data.dart';
import 'package:firebase_project/viewModel/checkout/checkout_view_model.dart';
import 'package:firebase_project/waleedWidget/elevated_button_widget.dart';
import 'package:firebase_project/waleedWidget/list_view_builder_widget_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quick_log/quick_log.dart';

class CheckoutSummaryView extends StatefulWidget {
  const CheckoutSummaryView({super.key});

  @override
  State<CheckoutSummaryView> createState() => _CheckoutSummaryViewState();
}

class _CheckoutSummaryViewState extends State<CheckoutSummaryView> {
  final log = const Logger('CheckoutSummaryView');
  List cartData = [];
  List address = [];
  List creditCard = [];
  List summary = [];
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await SummaryUtils().loadData();
    setState(() {
      cartData = data["cartData"];
      address = data["address"];
      creditCard = data["creditCard"];
      summary = [cartData[0], address[0], creditCard[0]];
      log.info(summary.runtimeType);
    });
  }

  @override
  Widget build(BuildContext context) {
    final checkoutViewModel = context.read<CheckoutViewModel>();

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
                    onPressedCall: () => Navigator.pop(context)),
              BlocListener<CheckoutViewModel, CheckoutStates>(
                listener: (context, states) {
                  if (states is LoadingCheckoutStates) {
                    EasyLoading.show(status: "Loading...");
                  } else if (states is SuccessCheckoutStates) {
                    EasyLoading.dismiss();
                    Navigator.of(context).push(
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          child: NavigationBarApp(
                            index: 0,
                          )),
                    );
                    HivePreferencesData().deleteFromHive(
                        boxName: HiveBoxes.cartBox, key: HiveKeys.cartData);
                    HivePreferencesData().deleteFromHive(
                        boxName: HiveBoxes.cartBox, key: HiveKeys.totalPrice);
                    AwesomeNotificationsServices().showNotifications(
                      titleNotification: "Your Order is Confirmed",
                      bodyNotification:
                          "Thank you for purchasing from our store! Your order #${states.orderId} is in processing and will be shipped soon",
                    );
                  } else if (states is FailureCheckoutStates) {
                    EasyLoading.showError(states.message);
                  }
                },
                child: ElevatedButtonWidget(
                  text: "PAY",
                  fontSize: 14.0,
                  textColor: Colors.white,
                  elevatedColor: const Color(0xff00C569),
                  elevatedWidth: 146.0,
                  elevatedHeight: 50.0,
                  onPressedCall: () async {
                    await CheckInternetUtils().checkInternetConnection();
                    if (CheckInternetUtils.checkInternet) {
                      checkoutViewModel.uploadDataViewModel(summary);
                    } else {
                      EasyLoading.showError("Check the Internet first");
                    }
                  },
                ),
              )
            ],
          )),
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xff00C569)),
        ),
        centerTitle: true,
        title: Text(
          "Summary",
          style: GlobalUtils.googleFontsFunction(
            fontWeightText: FontWeight.bold,
            fontSizeText: 20.0.sp,
          ),
        ),
      ),
      body: cartData.isEmpty || cartData[0].isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xff00C569)))
          : Padding(
              padding: EdgeInsets.only(bottom: 90.0.h),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      ProductListViewWidget(products: cartData[0]),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 23.0.h),
                        child: Divider(
                          color: Color(0xffEBEBEB),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 16.0.w,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 19.0.h),
                                child: Text(
                                  "Shipping Address",
                                  style: GlobalUtils.googleFontsFunction(
                                    fontWeightText: FontWeight.bold,
                                    fontSizeText: 18.0.sp,
                                  ),
                                ),
                              ),
                              Text(
                                address[0]["locality"],
                                style: GlobalUtils.googleFontsFunction(
                                  fontSizeText: 16.0.sp,
                                ),
                              ),
                              Text(
                                address[0]["street"],
                                style: GlobalUtils.googleFontsFunction(
                                  fontSizeText: 16.0.sp,
                                ),
                              ),
                              Text(
                                address[0]["country"],
                                style: GlobalUtils.googleFontsFunction(
                                  fontSizeText: 16.0.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 30.0.h),
                        child: Divider(
                          color: Color(0xffEBEBEB),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 16.0.w,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 19.0.h),
                                child: Text(
                                  "Payment",
                                  style: GlobalUtils.googleFontsFunction(
                                    fontSizeText: 18.0.sp,
                                    fontWeightText: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                'Card Holder: ${creditCard[0]["card_holder"]}',
                                style: GlobalUtils.googleFontsFunction(
                                    fontSizeText: 16.0.sp,
                                    colorText: Colors.black87),
                              ),
                              8.0.verticalSpace,
                              Text(
                                'Card Number: ${creditCard[0]["card_number"]}',
                                style: GlobalUtils.googleFontsFunction(
                                    fontSizeText: 16.0.sp,
                                    colorText: Colors.black54),
                              ),
                              8.0.verticalSpace,
                              Text(
                                'Expiry Date: ${creditCard[0]["expiry_date"]}',
                                style: GlobalUtils.googleFontsFunction(
                                    fontSizeText: 16.0.sp,
                                    colorText: Colors.black54),
                              ),
                              8.0.verticalSpace,
                              Text(
                                'CVV Code: ${creditCard[0]["cvv_code"]}',
                                style: GlobalUtils.googleFontsFunction(
                                    fontSizeText: 16.0.sp,
                                    colorText: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
