import 'package:firebase_project/utility/global_utils.dart';
import 'package:firebase_project/waleedWidget/list_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quick_log/quick_log.dart';
import '../../states/explore_states/explore_add_reviews_states.dart';
import '../../states/explore_states/explore_get_reviews_states.dart';
import '../../utility/explore_utils.dart';
import '../../viewModel/explore/explore_add_reviews_view_model.dart';
import '../../viewModel/explore/explore_get_reviews_view_model.dart';
import '../../waleedWidget/cached_network_widget.dart';
import '../../waleedWidget/elevated_button_widget.dart';
import '../../waleedWidget/text_filed_widget.dart';

class ExploreReviewsView extends StatefulWidget {
  final String productName;
  const ExploreReviewsView({super.key, required this.productName});

  @override
  State<ExploreReviewsView> createState() => _ExploreReviewsViewState();
}

class _ExploreReviewsViewState extends State<ExploreReviewsView> {
  final log = const Logger('ExploreReviewsView');
  final ExploreDetailsUtils exploreDetails = ExploreDetailsUtils();

  @override
  void initState() {
    ExploreDetailsUtils.reviewsController.clear();
    final exploreReviewsCubit = context.read<ExploreGetReviewsViewModel>();
    exploreReviewsCubit.listenToReviews((reviews) {}, widget.productName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final exploreAddReviewsViewModel =
        context.read<ExploreAddReviewsViewModel>();
    return Scaffold(
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
          "Reviews",
          style: GlobalUtils.googleFontsFunction(
            fontSizeText: 20.0.sp,
            fontWeightText: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Center(
              child: RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 2.0.w),
                itemBuilder: (context, _) => const Icon(
                  Icons.star_rounded,
                  color: Color(0xffEBE300),
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    exploreDetails.rating = rating;
                  });
                },
              ),
            ),
            15.0.verticalSpace,
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0.w),
              child: TextFiledWidget(
                widgetController: ExploreDetailsUtils.reviewsController,
                backgroundColor: Colors.white,
                borderColor: const Color(0xff00C569),
                icon: Icons.reviews_outlined,
                enabled: exploreDetails.rating != 0.0,
                hintText: "Write your review [Optional]",
                hintTextStyle: GlobalUtils.googleFontsFunction(
                  fontSizeText: 14.0.sp,
                ),
              ),
            ),
            BlocListener<ExploreAddReviewsViewModel, ExploreAddReviewsStates>(
              listener: (context, state) {
                if (state is LoadingExploreAddReviewsStates) {
                  EasyLoading.show(status: "Loading ..");
                } else if (state is SuccessExploreAddReviewsStates) {
                  EasyLoading.dismiss();
                  ExploreDetailsUtils.reviewsController.clear();
                  //The function that display the reviews is in initial State
                } else if (state is FailureExploreAddReviewsStates) {
                  EasyLoading.showError(state.errorMessage);
                }
              },
              child: Container(
                alignment: Alignment.topRight,
                margin:
                    EdgeInsets.only(top: 17.0.h, right: 22.0.w, bottom: 15.0.h),
                child: ElevatedButtonWidget(
                  text: "Post",
                  fontSize: 14.0,
                  textColor: Colors.white,
                  elevatedColor: const Color(0xff00C569),
                  elevatedWidth: 115.0,
                  elevatedHeight: 45.0,
                  onPressedCall: () {
                    // The Data of user pass in Model
                    exploreAddReviewsViewModel.addReviewsViewModel(
                      userReview:
                          ExploreDetailsUtils.reviewsController.text.isEmpty
                              ? ""
                              : ExploreDetailsUtils.reviewsController.text,
                      userRating: exploreDetails.rating,
                      productName: widget.productName,
                    );
                  },
                ),
              ),
            ),
            SizedBox(
                width: 280.0.w,
                child: const Divider(
                  thickness: 2,
                )),
            15.0.verticalSpace,
            BlocBuilder<ExploreGetReviewsViewModel, ExploreGetReviewsStates>(
              builder: (context, state) {
                if (state is LoadingExploreGetReviewsStates) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff00C569),
                    ),
                  );
                } else if (state is SuccessExploreGetReviewsStates) {
                  final reviews = state.reviewsModel;
                  if (reviews.isEmpty) {
                    return const Center(
                      child: Text("No reviews available"),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        log.info(reviews.length);
                        final review = reviews[index];
                        if (review.userReview.isNotEmpty) {
                          return ListTileWidget(
                            titleWidget: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 12.0.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          review.userName,
                                          style:
                                              GlobalUtils.googleFontsFunction(
                                            fontSizeText: 14.0.sp,
                                            fontWeightText: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      RatingBarIndicator(
                                        rating: review.userRating,
                                        itemBuilder: (context, _) => const Icon(
                                            Icons.star_rounded,
                                            color: Color(0xffEBE300)),
                                        itemCount: 5,
                                        itemSize: 16.0.sp,
                                        direction: Axis.horizontal,
                                      ),
                                    ],
                                  ),
                                ),
                                4.0.h.verticalSpace,
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4.0.h),
                                  child: Text(
                                    review.userReview,
                                    style: GlobalUtils.googleFontsFunction(
                                      fontSizeText: 14.0.sp,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      review.date,
                                      style: GlobalUtils.googleFontsFunction(
                                          fontSizeText: 11.0.sp,
                                          colorText: Colors.grey[500]),
                                    ),
                                    10.0.horizontalSpace,
                                    Text(
                                      review.timestamp,
                                      style: GlobalUtils.googleFontsFunction(
                                          fontSizeText: 11.0.sp,
                                          colorText: Colors.grey[500]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            leadingWidget: Transform.translate(
                              offset: const Offset(0, -13),
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10.0.h),
                                child: ClipOval(
                                  child: CachedNetworkWidget(
                                    imageUrl: review.userImage,
                                    imageWidth: 46.0.r,
                                    imageHeight: 46.0.r,
                                    imageFit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  );
                } else if (state is FailureExploreGetReviewsStates) {
                  return Center(
                    child: Text(state.errorMessage),
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
