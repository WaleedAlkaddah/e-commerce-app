import 'package:firebase_project/model/explore/firebase_explore_model.dart';

abstract class ExploreSearchStates {}

class InitialExploreSearchStates extends ExploreSearchStates {}

class LoadingExploreSearchStates extends ExploreSearchStates {}

class SuccessExploreSearchStates extends ExploreSearchStates {
  final List<ProductModel> searchResult;

  SuccessExploreSearchStates({
    required this.searchResult,
  });
}

class FailureExploreSearchStates extends ExploreSearchStates {
  final String errorMessage;
  FailureExploreSearchStates(this.errorMessage);
}
