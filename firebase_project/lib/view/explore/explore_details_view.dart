import 'package:firebase_project/model/explore/firebase_explore_model.dart';
import 'package:firebase_project/utility/global_utils.dart';
import 'package:firebase_project/utility/hive_constants.dart';
import 'package:firebase_project/utility/hive_preferences_data.dart';
import 'package:firebase_project/view/explore/explore_reviews_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quick_log/quick_log.dart';
import 'package:readmore/readmore.dart';
import '../../utility/explore_utils.dart';
import '../../waleedWidget/cached_network_widget.dart';
import '../../waleedWidget/elevated_button_widget.dart';

class ExploreDetailsView<T extends ProductModel> extends StatefulWidget {
  final T model;
  const ExploreDetailsView({super.key, required this.model});

  @override
  State<ExploreDetailsView> createState() => _ExploreDetailsViewState();
}

class _ExploreDetailsViewState extends State<ExploreDetailsView> {
  final log = const Logger('ExploreDetailsView');
  late final List<String> colorList;
  final HivePreferencesData hivePreferencesData = HivePreferencesData();
  final ExploreDetailsUtils exploreDetails = ExploreDetailsUtils();
  @override
  void initState() {
    log.info(widget.model.runtimeType);
    log.info(widget.model);
    checkIfFavorite();
    getColor();
    super.initState();
  }

  void getColor() {
    final color = widget.model;
    colorList = color.color;
    log.info(colorList, includeStackTrace: false);
  }

  Future<void> checkIfFavorite() async {
    final favorites = await hivePreferencesData.retrieveHiveData(
        boxName: HiveBoxes.favoritesBox, key: HiveKeys.favoritesData);
    setState(() {
      ExploreDetailsUtils.isFav =
          favorites.any((item) => item['name'] == widget.model.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Color?> colors = colorList
        .map((color) => ExploreDetailsUtils().getColorFromName(color.trim()))
        .toList();
    final product = widget.model;
    return Scaffold(
      extendBodyBehindAppBar: true,
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
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "PRICE",
                    style: GlobalUtils.googleFontsFunction(
                      fontSizeText: 12.0.sp,
                      colorText: Color(0xff929292),
                      fontWeightText: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "\$${product.price.toStringAsFixed(1)}",
                    style: GlobalUtils.googleFontsFunction(
                      fontSizeText: 18.0.sp,
                      colorText: Color(0xff00C569),
                      fontWeightText: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            10.0.horizontalSpace,
            product.count > 0
                ? ElevatedButtonWidget(
                    text: "ADD",
                    fontSize: 14.0,
                    textColor: Colors.white,
                    elevatedColor: const Color(0xff00C569),
                    elevatedWidth: 146.0,
                    elevatedHeight: 50.0,
                    onPressedCall: () async {
                      final Map<String, dynamic> dataStored = {
                        'docId': widget.model.runtimeType.toString(),
                        'name': product.name,
                        "brand": product.brand,
                        'price': product.price,
                        'image': product.image,
                        'quantity': product.quantity,
                        'count': product.count,
                        'real_price': product.price
                      };

                      ExploreDetailsUtils().cartDetails(
                        dataStored: dataStored,
                      );
                    })
                : Container(),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 84.0.h),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 400.0.h,
              floating: false,
              pinned: false,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
              ),
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: Color(0xff000000)),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.only(right: 16.0.w),
                  width: 40.0.w,
                  height: 40.0.h,
                  decoration: const BoxDecoration(
                    color: Color(0xffFFFFFF),
                    shape: BoxShape.circle,
                  ),
                  child: InkWell(
                    child: ExploreDetailsUtils.isFav
                        ? Icon(Icons.star, color: Colors.black, size: 27.0.sp)
                        : Icon(Icons.star_border,
                            color: Colors.black, size: 27.0.sp),
                    onTap: () async {
                      setState(() {
                        ExploreDetailsUtils.isFav = !ExploreDetailsUtils.isFav;
                      });
                      final dataStored = {
                        "name": product.name,
                        "image": product.image,
                        "price": product.price
                      };
                      if (ExploreDetailsUtils.isFav) {
                        await hivePreferencesData.storeHiveData(
                            boxName: HiveBoxes.favoritesBox,
                            key: HiveKeys.favoritesData,
                            value: dataStored);
                      } else {
                        await hivePreferencesData.deleteFromHive(
                            boxName: HiveBoxes.favoritesBox,
                            key: HiveKeys.favoritesData,
                            nameToDelete: product.name);
                      }
                    },
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  width: 390.0.w,
                  height: 476.96.h,
                  color: const Color(0xffe8e8e8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkWidget(
                      imageUrl: product.image,
                      imageWidth: 200.0.w,
                      imageHeight: 200.0.h,
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    margin: EdgeInsets.only(
                        left: 16.0.w, top: 17.0.h, bottom: 10.0.h),
                    child: Text(
                      product.name,
                      style: GlobalUtils.googleFontsFunction(
                        fontSizeText: 26.0.sp,
                        fontWeightText: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 18.0.w, bottom: 20.0.h),
                    child: Row(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          color: product.count > 0
                              ? const Color(0xff00C569)
                              : Colors.red,
                          size: 20.0.sp,
                        ),
                        5.0.horizontalSpace,
                        Text(
                          product.count > 0
                              ? '${product.count} left'
                              : 'Out of stock',
                          style: GlobalUtils.googleFontsFunction(
                            fontSizeText: 14.0.sp,
                            colorText: product.count > 0
                                ? const Color(0xff00C569)
                                : Colors.red,
                            fontWeightText: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50.0.h,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          10.0.horizontalSpace,
                          buildContainer("Size", product.size),
                          buildContainer("Type", product.type),
                          buildColorContainer(colors),
                          buildContainer("Others",
                              "${ExploreDetailsUtils().getProductType(product)}cm"),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 30.0.h, bottom: 10.0.h, left: 16.0.w),
                    child: Text(
                      "Description",
                      style: GlobalUtils.googleFontsFunction(
                        fontSizeText: 18.0.sp,
                        fontWeightText: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16.0.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: ReadMoreText(
                            product.description,
                            trimMode: TrimMode.Line,
                            trimLines: 2,
                            style: GlobalUtils.googleFontsFunction(
                              fontSizeText: 14.0.sp,
                            ),
                            colorClickableText: const Color(0xff00C569),
                            trimCollapsedText: 'Read more',
                            trimExpandedText: 'Read less',
                            moreStyle: GlobalUtils.googleFontsFunction(
                              fontSizeText: 14.0.sp,
                              colorText: Color(0xff00C569),
                              fontWeightText: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 30.0.h, bottom: 8.0.h, left: 16.0.w),
                    child: Text(
                      "Reviews",
                      style: GlobalUtils.googleFontsFunction(
                        fontSizeText: 18.0.sp,
                        fontWeightText: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16.0.w),
                    child: Text(
                      "Please take a moment to rate the product and share your thoughts with us. Your feedback helps us improve and allows other users to make informed decisions.",
                      style: GlobalUtils.googleFontsFunction(
                        fontSizeText: 14.0.sp,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            child: ExploreReviewsView(
                              productName: product.name,
                            )),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 16.0.w),
                      child: Text(
                        "Write your review",
                        style: GlobalUtils.googleFontsFunction(
                          fontSizeText: 14.0.sp,
                          colorText: Color(0xff00C569),
                          fontWeightText: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  15.0.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContainer(String label, String value) {
    return Container(
      height: 40.0.h,
      padding: EdgeInsets.symmetric(horizontal: 10.0.w),
      margin: EdgeInsets.symmetric(horizontal: 5.0.w),
      decoration: ExploreDetailsUtils().boxDecoration(),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: GlobalUtils.googleFontsFunction(
              fontSizeText: 14.0.sp,
              colorText: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: GlobalUtils.googleFontsFunction(
              fontSizeText: 14.0.sp,
              fontWeightText: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildColorContainer(List<Color?> colors) {
    return Container(
      height: 40.0.h,
      padding: EdgeInsets.symmetric(horizontal: 10.0.w),
      margin: EdgeInsets.symmetric(horizontal: 5.0.w),
      decoration: ExploreDetailsUtils().boxDecoration(),
      child: Row(
        children: [
          Text(
            "Color: ",
            style: GlobalUtils.googleFontsFunction(
              fontSizeText: 14.0.sp,
              colorText: Colors.grey.shade700,
            ),
          ),
          Row(
            children: colors
                .where((color) => color != null)
                .map((color) => Container(
                      height: 20.0.r,
                      width: 20.0.r,
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
