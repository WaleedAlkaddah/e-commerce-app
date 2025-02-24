abstract class ExploreAddReviewsStates {}

class InitialExploreAddReviewsStates extends ExploreAddReviewsStates {}

class LoadingExploreAddReviewsStates extends ExploreAddReviewsStates {}

class SuccessExploreAddReviewsStates extends ExploreAddReviewsStates {}

class FailureExploreAddReviewsStates extends ExploreAddReviewsStates {
  final String errorMessage;
  FailureExploreAddReviewsStates(this.errorMessage);
}
