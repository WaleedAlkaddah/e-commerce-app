import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_log/quick_log.dart';
import '../../model/explore/firebase_explore_model.dart';
import '../../states/explore_states/explore_get_reviews_states.dart';

class ExploreGetReviewsViewModel extends Cubit<ExploreGetReviewsStates> {
  ExploreGetReviewsViewModel() : super(InitialExploreGetReviewsStates());
  final log = const Logger('ExploreGetReviewsViewModel');
  List<ReviewsModel> reviewsList = [];

  void listenToReviews(
      Function(List<ReviewsModel>) onReviewsChanged, String key) async {
    emit(LoadingExploreGetReviewsStates());
    final DatabaseReference reviewsRef =
        FirebaseDatabase.instance.ref('reviews');
    reviewsRef.child(key).onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        List<ReviewsModel> tempReviewsList = [];

        data.forEach((reviewID, reviewData) {
          if (reviewData is Map<dynamic, dynamic>) {
            Map<String, dynamic> reviewDataMap =
                Map<String, dynamic>.from(reviewData);
            tempReviewsList.add(ReviewsModel.fromMap(reviewDataMap));
          }
        });

        emit(SuccessExploreGetReviewsStates(tempReviewsList));
        onReviewsChanged(tempReviewsList);
      } else {
        emit(SuccessExploreGetReviewsStates([]));
        onReviewsChanged([]);
      }
    }, onError: (error) {
      emit(FailureExploreGetReviewsStates('Failed to fetch reviews: $error'));
      log.error('Failed to fetch reviews: $error');
    });
  }
}
