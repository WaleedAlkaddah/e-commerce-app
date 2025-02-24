import 'package:firebase_project/utility/cart_utils.dart';
import 'package:firebase_project/utility/global_utils.dart';
import 'package:firebase_project/utility/hive_constants.dart';
import 'package:firebase_project/utility/hive_preferences_data.dart';
import 'package:firebase_project/waleedWidget/cached_network_widget.dart';
import 'package:firebase_project/waleedWidget/list_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quick_log/quick_log.dart';
import 'package:toastification/toastification.dart';

class AccountWishlistView extends StatefulWidget {
  const AccountWishlistView({super.key});

  @override
  State<AccountWishlistView> createState() => _AccountWishlistViewState();
}

class _AccountWishlistViewState extends State<AccountWishlistView> {
  final log = const Logger('AccountWishlistView');
  List<dynamic> wishList = [];
  final GlobalUtils globalUtils = GlobalUtils();
  final CartUtils cartUtils = CartUtils();
  final HivePreferencesData hivePreferencesData = HivePreferencesData();
  @override
  void initState() {
    getWishList();
    super.initState();
  }

  Future<void> getWishList() async {
    final retrievedData = await HivePreferencesData().retrieveHiveData(
        boxName: HiveBoxes.favoritesBox, key: HiveKeys.favoritesData);
    if (retrievedData == null) {
      wishList = [];
    } else {
      setState(() {
        wishList = retrievedData;
      });
    }

    log.info(wishList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Wishlist",
          style: GlobalUtils.googleFontsFunction(
            fontWeightText: FontWeight.bold,
            fontSizeText: 20.0.sp,
          ),
        ),
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
      ),
      body: wishList.isEmpty
          ? const Center(child: Text("No Wishlist found!"))
          : ListView.builder(
              itemCount: wishList.length,
              itemBuilder: (context, index) {
                final item = wishList[index];
                return Dismissible(
                  key: Key(item.toString()),
                  onDismissed: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      await hivePreferencesData.deleteFromHive(
                        boxName: HiveBoxes.favoritesBox,
                        nameToDelete: item["name"],
                        key: HiveKeys.favoritesData,
                      );
                      GlobalUtils().showCustomSnackBar(
                        message: "Removed!",
                        title: "Cart",
                        duration: 1,
                        type: ToastificationType.info,
                      );
                    }
                  },
                  background: globalUtils.slideLeftBackground(),
                  child: Card(
                    color: Colors.white,
                    shadowColor: const Color(0xff00C569),
                    margin: EdgeInsets.all(8.0.w.h),
                    child: ListTileWidget(
                      leadingWidget: CachedNetworkWidget(
                        imageUrl: item['image'],
                        imageWidth: 50.0,
                        imageHeight: 50.0,
                        imageFit: BoxFit.contain,
                      ),
                      titleWidget: Text(
                        item['name'],
                        style: GlobalUtils.googleFontsFunction(
                          fontWeightText: FontWeight.bold,
                          fontSizeText: 16.0.sp,
                        ),
                      ),
                      subtitleWidget: Text(
                        '\$${item['price']}',
                        style: GlobalUtils.googleFontsFunction(
                          fontWeightText: FontWeight.normal,
                          fontSizeText: 14.0.sp,
                          colorText: Color(0xff00C569),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
