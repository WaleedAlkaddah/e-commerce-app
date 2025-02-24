import '../../model/explore/firebase_explore_model.dart';

abstract class ExploreGetHomeState {}

class InitialExploreGetHomeState extends ExploreGetHomeState {}

class LoadingExploreGetHomeState extends ExploreGetHomeState {}

class SuccessExploreGetHomeState extends ExploreGetHomeState {
  final List<WatchesModel> watches;
  final List<PhonesModel> phones;
  final List<ProductModel> products;
  SuccessExploreGetHomeState({
    required this.products,
    required this.watches,
    required this.phones,
  });
}

class FailureExploreGetHomeState extends ExploreGetHomeState {
  final String errorMessage;
  FailureExploreGetHomeState(this.errorMessage);
}
