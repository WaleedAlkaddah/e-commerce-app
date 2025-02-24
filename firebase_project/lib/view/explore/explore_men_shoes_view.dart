import 'package:firebase_project/utility/global_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quick_log/quick_log.dart';
import '../../states/explore_states/explore_get_shoes_states.dart';
import '../../utility/explore_utils.dart';
import '../../viewModel/explore/explore_get_shoes_view_model.dart';
import '../../waleedWidget/grid_view_builder_widget.dart';
import 'explore_details_view.dart';

class ExploreMenShoesView extends StatefulWidget {
  const ExploreMenShoesView({super.key});

  @override
  State<ExploreMenShoesView> createState() => _ExploreMenShoesViewState();
}

class _ExploreMenShoesViewState extends State<ExploreMenShoesView>
    with SingleTickerProviderStateMixin {
  final log = const Logger('ExploreMenShoesView');
  late final ExploreGetShoesViewModel exploreGetShoesViewModel;
  @override
  void initState() {
    ExploreManShoesUtils.tabController = TabController(length: 4, vsync: this);
    ExploreManShoesUtils.tabController.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      exploreGetShoesViewModel = context.read<ExploreGetShoesViewModel>();
      exploreGetShoesViewModel.getShoesDataViewModel();
    });
    super.initState();
  }

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
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xff00C569)),
        ),
        centerTitle: true,
        title: Text(
          "Man Shoes",
          style: GlobalUtils.googleFontsFunction(
            fontSizeText: 18.0.sp,
            fontWeightText: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          indicatorColor: const Color(0xff00C569),
          labelColor: const Color(0xff00C569),
          controller: ExploreManShoesUtils.tabController,
          padding: EdgeInsets.symmetric(horizontal: 2.0.w),
          tabs: [
            Tab(
              child: Text(
                "Balance",
                style: GlobalUtils.googleFontsFunction(
                  fontSizeText: 15.0.sp,
                  fontWeightText: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Nike",
                style: GlobalUtils.googleFontsFunction(
                  fontSizeText: 15.0.sp,
                  fontWeightText: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Adidas",
                style: GlobalUtils.googleFontsFunction(
                  fontSizeText: 15.0.sp,
                  fontWeightText: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Puma",
                style: GlobalUtils.googleFontsFunction(
                  fontSizeText: 15.0.sp,
                  fontWeightText: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: ExploreManShoesUtils.tabController,
        children: [
          buildShoesBodyContent(ShoesType.newBalance),
          buildShoesBodyContent(ShoesType.nike),
          buildShoesBodyContent(ShoesType.adidas),
          buildShoesBodyContent(ShoesType.puma),
        ],
      ),
    );
  }

  Widget buildShoesBodyContent(ShoesType shoesType) {
    return BlocBuilder<ExploreGetShoesViewModel, ExploreGetShoesStates>(
        builder: (context, state) {
      if (state is LoadingExploreGetShoesStates) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xff00C569),
          ),
        );
      }
      if (state is SuccessExploreGetShoesStates) {
        final shoes = ExploreManShoesUtils.getShoesListByType(state, shoesType);
        return GridViewBuilderWidget(
          dataList: shoes,
          onTapCall: (index) {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.size,
                alignment: Alignment.center,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: ExploreDetailsView(
                  model: shoes.first,
                ),
              ),
            );
          },
        );
      } else if (state is FailureExploreGetShoesStates) {
        return Center(
          child: Text("No Shoes Available ${state.errorMessage}"),
        );
      }
      return const Center(child: Text("No Shoes Available"));
    });
  }
}
