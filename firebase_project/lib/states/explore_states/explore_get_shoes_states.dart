import '../../model/explore/firebase_explore_model.dart';

abstract class ExploreGetShoesStates {}

class InitialExploreGetShoesStates extends ExploreGetShoesStates {}

class LoadingExploreGetShoesStates extends ExploreGetShoesStates {}

class SuccessExploreGetShoesStates extends ExploreGetShoesStates {
  final List<ShoesModel> adidasShoes;
  final List<ShoesModel> pumaShoes;
  final List<ShoesModel> newBalanceShoes;
  final List<ShoesModel> nikeShoes;
  SuccessExploreGetShoesStates({
    required this.shoes,
    required this.adidasShoes,
    required this.pumaShoes,
    required this.newBalanceShoes,
    required this.nikeShoes,
  });
  final List<ShoesModel> shoes;
}

class FailureExploreGetShoesStates extends ExploreGetShoesStates {
  final String errorMessage;
  FailureExploreGetShoesStates(this.errorMessage);
}
