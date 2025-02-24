import 'package:firebase_project/model/explore/firebase_explore_model.dart';

abstract class ExploreGetReviewsStates {}

class InitialExploreGetReviewsStates extends ExploreGetReviewsStates {}

class LoadingExploreGetReviewsStates extends ExploreGetReviewsStates {}

class SuccessExploreGetReviewsStates extends ExploreGetReviewsStates {
  final List<ReviewsModel> reviewsModel;
  SuccessExploreGetReviewsStates(this.reviewsModel);
}

class FailureExploreGetReviewsStates extends ExploreGetReviewsStates {
  final String errorMessage;
  FailureExploreGetReviewsStates(this.errorMessage);
}
