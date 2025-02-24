import 'package:firebase_project/model/explore/firebase_explore_model.dart';
import 'package:firebase_project/utility/global_utils.dart';
import 'package:firebase_project/view/explore/explore_details_view.dart';
import 'package:firebase_project/waleedWidget/grid_view_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class ExploreShowSearchView extends StatelessWidget {
  final List<ProductModel> searchResult;

  const ExploreShowSearchView({super.key, required this.searchResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xff00C569)),
        ),
        title: Text(
          "Products",
          style: GlobalUtils.googleFontsFunction(
              fontSizeText: 20.0.sp, fontWeightText: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          10.0.verticalSpace,
          GridViewBuilderWidget(
            dataList: searchResult,
            onTapCall: (index) {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: ExploreDetailsView(
                    model: searchResult.first,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
