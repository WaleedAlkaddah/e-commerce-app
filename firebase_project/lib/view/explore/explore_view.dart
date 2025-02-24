import 'package:firebase_project/states/explore_states/explore_get_home_state.dart';
import 'package:firebase_project/states/explore_states/explore_search_states.dart';
import 'package:firebase_project/utility/check_internet_utils.dart';
import 'package:firebase_project/view/explore/explore_details_view.dart';
import 'package:firebase_project/view/explore/explore_show_search_view.dart';
import 'package:firebase_project/viewModel/explore/explore_get_home_view_model.dart';
import 'package:firebase_project/viewModel/explore/explore_search_view_model.dart';
import 'package:firebase_project/waleedWidget/category_items_widget.dart';
import 'package:firebase_project/waleedWidget/grid_view_builder_widget.dart';
import 'package:firebase_project/waleedWidget/list_tile_widget.dart';
import 'package:firebase_project/waleedWidget/text_filed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quick_log/quick_log.dart';
import '../../assetsPath/assets_path.dart';
import '../../utility/explore_utils.dart';
import '../../utility/global_utils.dart';
import 'explore_men_shoes_view.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final log = const Logger('ExploreView');
  late final ExploreGetHomeViewModel exploreGetHomeViewModel;
  late final ExploreSearchViewModel exploreSearchViewModel;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      exploreGetHomeViewModel = context.read<ExploreGetHomeViewModel>();
      exploreSearchViewModel = context.read<ExploreSearchViewModel>();
      exploreGetHomeViewModel.getHomeProductsViewModel();
    });
    CheckInternetUtils().checkInternetConnection();
    GlobalUtils().checkSignInMethod();
    super.initState();
  }

  Future<void> deleteHiveBox(String boxName) async {
    try {
      if (Hive.isBoxOpen(boxName)) {
        await Hive.box(boxName).close();
      }
      await Hive.deleteBoxFromDisk(boxName);
      log.fine('Box "$boxName" deleted successfully.');
    } catch (e) {
      log.error('Error deleting box "$boxName": $e');
    }
  }

  Future showBottomSheet() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Column(
          children: [
            15.0.verticalSpace,
            Text(
              "Choose Category",
              style: GlobalUtils.googleFontsFunction(
                  fontSizeText: 18.0.sp, fontWeightText: FontWeight.bold),
            ),
            15.0.verticalSpace,
            ListTileWidget(
              text: 'Phones',
              textStyle: GlobalUtils.googleFontsFunction(
                fontSizeText: 16.0.sp,
              ),
              onTap: () {
                setState(() {
                  ExploreUtils.selectedItem = 'phones';
                });
                Navigator.pop(context);
              },
            ),
            ListTileWidget(
              text: 'Shoes',
              textStyle: GlobalUtils.googleFontsFunction(
                fontSizeText: 16.0.sp,
              ),
              onTap: () {
                setState(() {
                  ExploreUtils.selectedItem = 'shoes';
                });
                Navigator.pop(context);
              },
            ),
            ListTileWidget(
              text: 'Watches',
              textStyle: GlobalUtils.googleFontsFunction(
                fontSizeText: 16.0.sp,
              ),
              onTap: () {
                setState(() {
                  ExploreUtils.selectedItem = 'watches';
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  search(String searchText) {
    if (ExploreUtils.selectedItem.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showBottomSheet();
        exploreSearchViewModel.getSearchResult(
            category: ExploreUtils.selectedItem, companyName: searchText);
      });
    } else {
      exploreSearchViewModel.getSearchResult(
          category: ExploreUtils.selectedItem, companyName: searchText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: BlocListener<ExploreSearchViewModel, ExploreSearchStates>(
          listener: (context, states) {
            if (states is LoadingExploreSearchStates) {
              EasyLoading.show(status: "Loading..");
            } else if (states is SuccessExploreSearchStates) {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: ExploreShowSearchView(
                    searchResult: states.searchResult,
                  ),
                ),
              );
              EasyLoading.dismiss();
            } else if (states is FailureExploreSearchStates) {
              EasyLoading.showError(states.errorMessage);
            }
          },
          child: SizedBox(
            width: 290.0.w,
            height: 40.0.h,
            child: TextFiledWidget(
              widgetController: ExploreUtils.searchController,
              backgroundColor: Colors.black.withValues(alpha: 0.1),
              cursorColor: const Color(0xff00C569),
              prefixIconColor: Colors.black,
              hintText: "Company Name (Apple,Samsung..)",
              hintTextStyle: GlobalUtils.googleFontsFunction(
                  fontSizeText: 14.0.sp, colorText: Colors.grey),
              textInputActionWidget: TextInputAction.go,
              onSubmittedFunction: (searchText) => search(searchText),
            ),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.0.w),
            width: 40.0.w,
            height: 40.0.h,
            decoration: const BoxDecoration(
              color: Color(0xff00C569),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.filter_list, color: Colors.white, size: 20.0.sp),
              onPressed: () {
                showBottomSheet();
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(
                      left: 16.0.w, top: 28.0.h, bottom: 20.0.h),
                  child: Text(
                    "Categories",
                    style: GlobalUtils.googleFontsFunction(
                        fontSizeText: 18.0.sp, fontWeightText: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 50.0.h),
                  width: 1.0.sw,
                  height: 132.0.h,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        16.0.horizontalSpace,
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  child: ExploreMenShoesView()),
                            );
                          },
                          child: const CategoryItemsWidget(
                            label: 'Men',
                            svgPath: AssetsPath.shoesMan,
                          ),
                        ),
                        20.0.horizontalSpace,
                        const CategoryItemsWidget(
                          label: 'Women',
                          svgPath: AssetsPath.shoesWomen,
                        ),
                        20.0.horizontalSpace,
                        const CategoryItemsWidget(
                          label: 'Mobiles',
                          svgPath: AssetsPath.mobiles,
                        ),
                        20.0.horizontalSpace,
                        const CategoryItemsWidget(
                          label: 'Gadgets',
                          svgPath: AssetsPath.gadgets,
                        ),
                        20.0.horizontalSpace,
                        const CategoryItemsWidget(
                          label: 'Gaming',
                          svgPath: AssetsPath.gaming,
                        ),
                        16.0.horizontalSpace,
                      ],
                    ),
                  )),
              BlocBuilder<ExploreGetHomeViewModel, ExploreGetHomeState>(
                builder: (context, state) {
                  if (state is LoadingExploreGetHomeState) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Color(0xff00C569),
                    ));
                  } else if (state is FailureExploreGetHomeState) {
                    return Center(
                      child: Text(
                        state.errorMessage,
                        style: GlobalUtils.googleFontsFunction(
                            fontSizeText: 16.0.sp, colorText: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (state is SuccessExploreGetHomeState) {
                    final products = state.products;
                    return GridViewBuilderWidget(
                      dataList: products,
                      onTapCall: (index) {
                        log.info(products[index].runtimeType);
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.size,
                            alignment: Alignment.center,
                            duration: Duration(milliseconds: 800),
                            curve: Curves.easeInOut,
                            child: ExploreDetailsView(
                              model: products[index],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                        child: Text(
                      "No data currently available",
                      style: GlobalUtils.googleFontsFunction(
                        fontSizeText: 16.0.sp,
                      ),
                    ));
                  }
                },
              ),
              15.0.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
