import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_log/quick_log.dart';
import '../../model/explore/firebase_explore_write_reviews_model.dart';
import '../../states/explore_states/explore_add_reviews_states.dart';

class ExploreAddReviewsViewModel extends Cubit<ExploreAddReviewsStates> {
  ExploreAddReviewsViewModel() : super(InitialExploreAddReviewsStates());
  final log = const Logger('ExploreAddReviewsViewModel');

  void addReviewsViewModel({
    required String userReview,
    required double userRating,
    required String productName,
  }) async {
    emit(LoadingExploreAddReviewsStates());
    final model = FirebaseExploreWriteReviewsModel();
    final checkModel = await model.addReviewsModel(
        userReview: userReview,
        userRating: userRating,
        productName: productName);
    checkModel.fold((failure) {
      log.error(failure.message, includeStackTrace: false);
      emit(FailureExploreAddReviewsStates(failure.message));
    }, (data) {
      log.fine(data, includeStackTrace: false);
      emit(SuccessExploreAddReviewsStates());
    });
  }
}
