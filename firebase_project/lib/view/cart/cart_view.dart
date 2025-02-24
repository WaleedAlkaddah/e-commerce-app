import 'package:firebase_project/states/cart_states/cart_count_states.dart';
import 'package:firebase_project/states/cart_states/cart_total_states.dart';
import 'package:firebase_project/utility/cart_utils.dart';
import 'package:firebase_project/utility/global_utils.dart';
import 'package:firebase_project/utility/hive_preferences_data.dart';
import 'package:firebase_project/view/checkOut/checkout_view.dart';
import 'package:firebase_project/viewModel/cart/cart_total_view_model.dart';
import 'package:firebase_project/waleedWidget/cached_network_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quick_log/quick_log.dart';
import 'package:toastification/toastification.dart';
import '../../viewModel/cart/cart_count_view_model.dart';
import '../../waleedWidget/elevated_button_widget.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  late CartCountViewModel cartCountViewModel;
  late CartTotalViewModel cartTotalViewModel;
  final GlobalUtils globalUtils = GlobalUtils();
  final log = const Logger('CartView');
  double totalPrice = 0.0;
  final CartUtils cartUtils = CartUtils();
  final HivePreferencesData hivePreferencesData = HivePreferencesData();
  @override
  void initState() {
    cartCountViewModel = context.read<CartCountViewModel>();
    cartTotalViewModel = context.read<CartTotalViewModel>();
    fetchedData();
    super.initState();
  }

  void fetchedData() async {
    await cartCountViewModel.loadCartViewModel();
    await cartTotalViewModel.getTotalPriceViewModel();
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 30.0.w, right: 117.0.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "TOTAL",
                    style: GlobalUtils.googleFontsFunction(
                        fontWeightText: FontWeight.bold,
                        fontSizeText: 12.0.sp,
                        colorText: Color(0xff929292)),
                  ),
                  BlocBuilder<CartTotalViewModel, CartTotalStates>(
                    builder: (context, state) {
                      if (state is LoadingCartTotalStates) {
                        return CircularProgressIndicator(
                          color: const Color(0xff00C569),
                          strokeWidth: 3.0.w,
                        );
                      }

                      if (state is SuccessCartTotalStates) {
                        return Text(
                          "\$${state.totalPrice.toStringAsFixed(1)}",
                          style: GlobalUtils.googleFontsFunction(
                              fontWeightText: FontWeight.bold,
                              fontSizeText: 18.0.sp,
                              colorText: Color(0xff00C569)),
                        );
                      }

                      return Text(
                        "0.00",
                        style: GlobalUtils.googleFontsFunction(
                            fontWeightText: FontWeight.bold,
                            fontSizeText: 18.0.sp,
                            colorText: Color(0xff00C569)),
                      );
                    },
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 30.0.w),
                child: ElevatedButtonWidget(
                  text: "Checkout",
                  fontSize: 14.0,
                  textColor: Colors.white,
                  elevatedColor: const Color(0xff00C569),
                  elevatedWidth: 146.0,
                  elevatedHeight: 50.0,
                  onPressedCall: () {
                    bool isCartEmpty = cartUtils.totalPrice.isNaN;

                    if (isCartEmpty) {
                      GlobalUtils().showCustomSnackBar(
                        message: "Your cart is empty!",
                        title: "Cart",
                        duration: 3,
                        type: ToastificationType.warning,
                      );
                    } else {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          child: CheckoutView(),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<CartCountViewModel, CartCountState>(
          builder: (context, state) {
        if (state is LoadingCartCountState) {
          return Center(
            child: CircularProgressIndicator(
              color: const Color(0xff00C569),
              strokeWidth: 3.0.w,
            ),
          );
        } else if (state is SuccessCartCountState) {
          return ListView.builder(
            itemCount: state.cartItems.length,
            itemBuilder: (context, index) {
              final cartData = state.cartItems[index];
              return Dismissible(
                key: Key(cartData.toString()),
                onDismissed: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    await cartUtils
                        .moveToFavorites(cartData.cast<String, dynamic>());
                    GlobalUtils().showCustomSnackBar(
                      message: "Added to favorites!",
                      title: "Favorites",
                      duration: 1,
                      type: ToastificationType.info,
                    );
                  } else if (direction == DismissDirection.endToStart) {
                    await cartUtils
                        .removeFromCart(cartData.cast<String, dynamic>());
                    GlobalUtils().showCustomSnackBar(
                      message: "Removed!",
                      title: "Cart",
                      duration: 1,
                      type: ToastificationType.info,
                    );
                  }
                  fetchedData();
                  setState(() {
                    state.cartItems.removeAt(index);
                  });
                },
                background: globalUtils.slideRightBackground(),
                secondaryBackground: globalUtils.slideLeftBackground(),
                child: Container(
                  width: 343.0.w,
                  margin: EdgeInsets.only(bottom: 16.0.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 120.0.h,
                        width: 120.0.w,
                        margin: EdgeInsets.only(left: 16.0.w, right: 30.0.w),
                        decoration: BoxDecoration(
                          color: const Color(0xffe8e8e8),
                          borderRadius: BorderRadius.circular(8.0.r),
                        ),
                        child: Center(
                          child: CachedNetworkWidget(
                            imageHeight: 120.0.h,
                            imageWidth: 120.0.w,
                            imageFit: BoxFit.contain,
                            imageUrl: cartData['image'],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartData['name'],
                              style: GlobalUtils.googleFontsFunction(
                                fontWeightText: FontWeight.bold,
                                fontSizeText: 16.0.sp,
                              ),
                            ),
                            Text(
                              "\$${cartData['price'].toStringAsFixed(1)}",
                              style: GlobalUtils.googleFontsFunction(
                                  fontWeightText: FontWeight.normal,
                                  fontSizeText: 16.0.sp,
                                  colorText: Color(0xff00C569)),
                            ),
                            8.0.verticalSpace,
                            Container(
                              height: 35.0.h,
                              margin: EdgeInsets.only(top: 14.0.h),
                              decoration: BoxDecoration(
                                color: const Color(0xfff0f0f0),
                                borderRadius: BorderRadius.circular(8.0.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    iconSize: 20.sp,
                                    onPressed: () async {
                                      await cartCountViewModel
                                          .increaseQuantityViewModel(
                                              cartData["name"]);
                                      await cartTotalViewModel
                                          .getTotalPriceViewModel();
                                    },
                                  ),
                                  Text(
                                    "${cartData["quantity"]}",
                                    style: GlobalUtils.googleFontsFunction(
                                      fontWeightText: FontWeight.bold,
                                      fontSizeText: 16.0.sp,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    iconSize: 20.sp,
                                    onPressed: () async {
                                      await cartCountViewModel
                                          .decreaseQuantityViewModel(
                                              cartData["name"]);
                                      await cartTotalViewModel
                                          .getTotalPriceViewModel();
                                    },
                                  ),
                                ],
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
          );
        } else if (state is FailureCartCountState) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('No items in the cart.'));
        }
      }),
    );
  }
}
