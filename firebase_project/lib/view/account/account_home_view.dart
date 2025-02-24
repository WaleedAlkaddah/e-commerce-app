import 'package:firebase_project/utility/global_utils.dart';
import 'package:firebase_project/view/account/account_edit_profile_view.dart';
import 'package:firebase_project/view/account/account_wishlist_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quick_log/quick_log.dart';
import '../../assetsPath/assets_path.dart';
import '../../states/account_states/account_home_states.dart';
import '../../utility/account_utils.dart';
import '../../utility/hive_preferences_data.dart';
import '../../viewModel/account/account_home_view_model.dart';
import '../../waleedWidget/cached_network_widget.dart';
import '../../waleedWidget/list_tile_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'account_cards_view.dart';
import 'account_shipping_address_view.dart';

class AccountHomeView extends StatefulWidget {
  const AccountHomeView({super.key});

  @override
  State<AccountHomeView> createState() => _AccountHomeViewState();
}

class _AccountHomeViewState extends State<AccountHomeView> {
  final log = const Logger('AccountHomeView');
  final HivePreferencesData hivePreferencesData = HivePreferencesData();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountHomeViewModel, AccountHomeStates>(
      builder: (context, state) {
        if (state is LoadingAccountHomeStates) {
          return const Center(
              child: CircularProgressIndicator(
            color: Color(0xff00C569),
          ));
        } else if (state is SuccessAccountHomeStates) {
          final user = state.firebaseAccountModel;
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 60.0.h, left: 16.0.w),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 25.0.w),
                          child: ClipOval(
                            child: CachedNetworkWidget(
                              imageUrl: user.image.isEmpty
                                  ? AccountHomeUtils.defaultImage
                                  : user.image,
                              imageHeight: 100.0.r,
                              imageWidth: 100.0.r,
                              imageFit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.firstName == user.lastName
                                    ? user.firstName
                                    : '${user.firstName} ${user.lastName}',
                                style: GlobalUtils.googleFontsFunction(
                                  fontSizeText: 26.0.sp,
                                  fontWeightText: FontWeight.bold,
                                  colorText: Colors.black,
                                ),
                              ),
                              Text(
                                user.email,
                                style: GlobalUtils.googleFontsFunction(
                                    fontSizeText: 14.0.sp,
                                    fontWeightText: FontWeight.bold,
                                    colorText: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0.h),
                          child: Opacity(
                            opacity: AccountHomeUtils.checkGoogle ? 0.5 : 1.0,
                            child: IgnorePointer(
                              ignoring: AccountHomeUtils.checkGoogle,
                              child: ListTileWidget(
                                text: 'Edit Profile',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                      child: AccountEditProfileView(
                                        userUid: user.uid,
                                        userFirstName: user.firstName,
                                        userLastName: user.lastName,
                                        userEmail: user.email,
                                        userImage: user.image,
                                      ),
                                    ),
                                  );
                                },
                                svgPath: AssetsPath.editProfile,
                                svgHeight: 40.0,
                                svgWidth: 40.0,
                                icon: Icons.arrow_forward_ios,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0.h),
                          child: ListTileWidget(
                            text: 'Shipping Address',
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    child: AccountShippingAddress(
                                      userId: user.uid,
                                    )),
                              );
                            },
                            svgPath: AssetsPath.shippingAddress,
                            svgHeight: 40.0,
                            svgWidth: 40.0,
                            icon: Icons.arrow_forward_ios,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0.h),
                          child: ListTileWidget(
                            text: 'Wishlist',
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    child: AccountWishlistView()),
                              );
                            },
                            svgPath: AssetsPath.wishList,
                            svgHeight: 40.0,
                            svgWidth: 40.0,
                            icon: Icons.arrow_forward_ios,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0.h),
                          child: ListTileWidget(
                            text: 'Cards',
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    child: AccountCardsView(
                                      userId: user.uid,
                                    )),
                              );
                            },
                            svgPath: AssetsPath.cards,
                            svgHeight: 40.0,
                            svgWidth: 40.0,
                            icon: Icons.arrow_forward_ios,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0.h),
                          child: ListTileWidget(
                            text: 'Logout',
                            onTap: () {
                              AccountLogoutUtils().handleLogoutSuccess(context);
                            },
                            svgPath: AssetsPath.logout,
                            svgHeight: 40.0,
                            svgWidth: 40.0,
                            icon: Icons.arrow_forward_ios,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is FailureAccountHomeStates) {
          return Center(
            child: Text(
              state.errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 18.0),
            ),
          );
        } else {
          return const Center(child: Text("Something went wrong!"));
        }
      },
    );
  }
}
