import 'package:firebase_project/services/firebase_notification_services.dart';
import 'package:firebase_project/view/account/account_home_view.dart';
import 'package:firebase_project/view/cart/cart_view.dart';
import 'package:firebase_project/view/explore/explore_view.dart';
import 'package:firebase_project/viewModel/account/account_home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quick_log/quick_log.dart';
import 'assetsPath/assets_path.dart';

class NavigationBarApp extends StatefulWidget {
  final int index;
  const NavigationBarApp({super.key, required this.index});

  @override
  State<NavigationBarApp> createState() => _NavigationBarAppState();
}

class _NavigationBarAppState extends State<NavigationBarApp> {
  final log = const Logger('NavigationBarApp');
  int selectedIndex = 0;
  @override
  void initState() {
    setState(() {
      selectedIndex = widget.index;
      if (selectedIndex == 0 || selectedIndex == 2) {
        fetchAccountData();
      }
    });

    super.initState();
  }

  void fetchAccountData() async {
    log.info("Fetching Account Data");
    context.read<AccountHomeViewModel>().getUserDataViewModel();
    Future.delayed(const Duration(seconds: 5), () async {
      await FirebaseNotificationServices().iniNotifications();
    });
  }

  List<Widget> get tabItems => [
        const Center(child: ExploreView()),
        const Center(child: CartView()),
        const Center(child: AccountHomeView()),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: tabItems[selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0xff707070).withValues(alpha: 0.2),
              spreadRadius: 2.0,
              blurRadius: 6.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: FlashyTabBar(
          selectedIndex: selectedIndex,
          animationDuration: const Duration(milliseconds: 300),
          showElevation: false,
          onItemSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: [
            FlashyTabBarItem(
              icon: SvgPicture.asset(
                AssetsPath.exploreIcon,
                width: 20.0.r,
                height: 20.0.r,
                fit: BoxFit.contain,
              ),
              activeColor: Colors.black,
              title: Text(
                'Explore',
                style: TextStyle(
                    fontFamily: "SF Pro Display",
                    fontSize: 14.0.sp,
                    color: Colors.black),
              ),
            ),
            FlashyTabBarItem(
              icon: SvgPicture.asset(
                AssetsPath.cartIcon,
                width: 20.0.r,
                height: 20.0.r,
                fit: BoxFit.contain,
              ),
              activeColor: Colors.black,
              title: Text(
                'Cart',
                style: TextStyle(
                    fontFamily: "SF Pro Display",
                    fontSize: 14.0.sp,
                    color: Colors.black),
              ),
            ),
            FlashyTabBarItem(
              icon: SvgPicture.asset(
                AssetsPath.accountIcon,
                width: 20.0.r,
                height: 20.0.r,
                fit: BoxFit.contain,
              ),
              activeColor: Colors.black,
              title: Text(
                'Account',
                style: TextStyle(
                    fontFamily: "SF Pro Display",
                    fontSize: 14.0.sp,
                    color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
