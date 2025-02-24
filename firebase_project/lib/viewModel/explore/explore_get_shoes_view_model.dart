import 'dart:async';
import 'package:firebase_project/utility/model_constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_log/quick_log.dart';
import '../../model/explore/firebase_explore_get_by_id_model.dart';
import '../../model/explore/firebase_explore_model.dart';
import '../../states/explore_states/explore_get_shoes_states.dart';

class ExploreGetShoesViewModel extends Cubit<ExploreGetShoesStates> {
  ExploreGetShoesViewModel() : super(InitialExploreGetShoesStates());
  final log = const Logger('ExploreGetShoesViewModel');

  Future<void> getShoesDataViewModel() async {
    emit(LoadingExploreGetShoesStates());

    final model = FirebaseExploreGetById();
    final checkModel = await model.getFieldFromFireStoreModel(
        collectionName: ModelConstantsCollection.imageCollection,
        docId: ModelConstantsDoc.shoes);

    checkModel.fold(
      (failure) {
        log.error("Failed to Get Shoes: ${failure.message}",
            includeStackTrace: false);
        emit(FailureExploreGetShoesStates(failure.message));
      },
      (data) {
        if (data.containsKey("shoes")) {
          final shoesList = data["shoes"];
          log.info(shoesList["adidas"].runtimeType);
          final List<ShoesModel> adidasShoesResult = (shoesList["adidas"]
                  as List<dynamic>)
              .map((item) => ShoesModel.fromJson(item as Map<String, dynamic>))
              .toList();
          log.info("Type of Variable: ${adidasShoesResult.runtimeType}",
              includeStackTrace: false);
          final List<ShoesModel> nikeShoesResult = (shoesList["nike"]
                  as List<dynamic>)
              .map((item) => ShoesModel.fromJson(item as Map<String, dynamic>))
              .toList();
          log.info("Type of Variable: ${nikeShoesResult.runtimeType}",
              includeStackTrace: false);

          final List<ShoesModel> newBalanceShoesResult = (shoesList[
                  "newbalance"] as List<dynamic>)
              .map((item) => ShoesModel.fromJson(item as Map<String, dynamic>))
              .toList();
          log.info("Type of Variable: ${newBalanceShoesResult.runtimeType}",
              includeStackTrace: false);

          final List<ShoesModel> pumaShoesResult = (shoesList["puma"]
                  as List<dynamic>)
              .map((item) => ShoesModel.fromJson(item as Map<String, dynamic>))
              .toList();
          log.info("Type of Variable: ${pumaShoesResult.runtimeType}",
              includeStackTrace: false);

          final List<ShoesModel> allShoes = [
            ...adidasShoesResult,
            ...nikeShoesResult,
            ...newBalanceShoesResult,
            ...pumaShoesResult,
          ];

          emit(SuccessExploreGetShoesStates(
              shoes: allShoes,
              adidasShoes: adidasShoesResult,
              pumaShoes: pumaShoesResult,
              newBalanceShoes: newBalanceShoesResult,
              nikeShoes: nikeShoesResult));
        } else {
          log.error("Failed to Get Shoes: No shoes key found in data.",
              includeStackTrace: false);
          emit(FailureExploreGetShoesStates("An unexpected error occurred"));
        }
      },
    );
  }
}
