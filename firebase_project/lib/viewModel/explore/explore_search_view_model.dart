import 'package:firebase_project/model/explore/firebase_explore_model.dart';
import 'package:firebase_project/model/explore/firebase_explore_search_model.dart';
import 'package:firebase_project/states/explore_states/explore_search_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_log/quick_log.dart';

class ExploreSearchViewModel extends Cubit<ExploreSearchStates> {
  ExploreSearchViewModel() : super(InitialExploreSearchStates());
  final log = const Logger('ExploreSearchViewModel');

  Future<void> getSearchResult(
      {required String category, required String companyName}) async {
    emit(LoadingExploreSearchStates());
    final model = FirebaseExploreSearchModel();
    final checkModel = await model.getSearchResultModel(
        category: category, companyName: companyName);
    checkModel.fold((failure) {
      log.error(failure);
      emit(FailureExploreSearchStates(failure.message));
    }, (data) {
      log.fine(data);
      List<ProductModel> matchedProducts = [];
      matchedProducts
          .addAll(data.map((e) => ProductModel.fromJson(e)).toList());
      emit(SuccessExploreSearchStates(searchResult: matchedProducts));
    });
  }
}
