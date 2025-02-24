import 'package:firebase_project/model/explore/firebase_explore_get_by_id_model.dart';
import 'package:firebase_project/model/explore/firebase_explore_model.dart';
import 'package:firebase_project/states/explore_states/explore_get_home_state.dart';
import 'package:firebase_project/utility/model_constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_log/quick_log.dart';

class ExploreGetHomeViewModel extends Cubit<ExploreGetHomeState> {
  ExploreGetHomeViewModel() : super(InitialExploreGetHomeState());
  final log = const Logger('ExploreGetHomeViewModel');

  Future<void> getHomeProductsViewModel() async {
    emit(LoadingExploreGetHomeState());
    final model = FirebaseExploreGetById();
    try {
      final checkModel = await model.getFieldFromFireStoreModel(
          collectionName: ModelConstantsCollection.imageCollection,
          docId: ModelConstantsDoc.watches);
      checkModel.fold((failure) {
        log.error("Failed while retrieve data: $failure");
        emit(FailureExploreGetHomeState(failure.message));
      }, (data) async {
        final Map<String, dynamic> watchesMap = data['watches'];
        log.info(watchesMap);
        final List<WatchesModel> appleWatches = (watchesMap["apple"]
                as List<dynamic>)
            .map((item) => WatchesModel.fromJson(item as Map<String, dynamic>))
            .toList();
        log.info(appleWatches.runtimeType);
        final List<WatchesModel> samsungWatches = (watchesMap["samsung"]
                as List<dynamic>)
            .map((item) => WatchesModel.fromJson(item as Map<String, dynamic>))
            .toList();
        log.info(samsungWatches.runtimeType);

        final List<WatchesModel> fitbitWatches = (watchesMap["fitbit"]
                as List<dynamic>)
            .map((item) => WatchesModel.fromJson(item as Map<String, dynamic>))
            .toList();
        log.info(fitbitWatches.runtimeType);

        final List<WatchesModel> garminWatches = (watchesMap["garmin"]
                as List<dynamic>)
            .map((item) => WatchesModel.fromJson(item as Map<String, dynamic>))
            .toList();
        log.info(garminWatches.runtimeType);
        final List<WatchesModel> allWatches = [
          ...appleWatches,
          ...samsungWatches,
          ...garminWatches,
          ...fitbitWatches
        ];
        log.info("Total watches retrieved:: ${allWatches.length}");
        final List<PhonesModel> allPhones = await getPhonesViewModel();
        final List<ProductModel> allProducts =
            List.from([...allPhones, ...allWatches])..shuffle();
        log.info("Total products retrieved: ${allProducts.length}");
        emit(SuccessExploreGetHomeState(
            watches: allWatches, phones: allPhones, products: allProducts));
      });
    } catch (e) {
      log.error("An unexpected error occurred: $e");
      emit(FailureExploreGetHomeState("An unexpected error occurred"));
    }
  }

  Future<List<PhonesModel>> getPhonesViewModel() async {
    final model = FirebaseExploreGetById();
    try {
      final checkModel = await model.getFieldFromFireStoreModel(
          collectionName: ModelConstantsCollection.imageCollection,
          docId: ModelConstantsDoc.phones);

      return checkModel.fold((failure) {
        log.error("Failed while retrieving data: ${failure.message}");
        emit(FailureExploreGetHomeState(failure.message));
        return [];
      }, (data) {
        if (!data.containsKey('phones')) {
          const errorMessage = "No valid phone data found in Firestore.";
          log.error(errorMessage);
          emit(FailureExploreGetHomeState(errorMessage));
          return [];
        }

        final Map<String, dynamic> phonesMap = data['phones'];

        try {
          final List<PhonesModel> applePhones = (phonesMap["apple"]
                  as List<dynamic>)
              .map((item) => PhonesModel.fromJson(item as Map<String, dynamic>))
              .toList();
          final List<PhonesModel> samsungPhones = (phonesMap["samsung"]
                  as List<dynamic>)
              .map((item) => PhonesModel.fromJson(item as Map<String, dynamic>))
              .toList();
          final List<PhonesModel> onePlusPhones = (phonesMap["oneplus"]
                  as List<dynamic>)
              .map((item) => PhonesModel.fromJson(item as Map<String, dynamic>))
              .toList();
          final List<PhonesModel> googlePhones = (phonesMap["google"]
                  as List<dynamic>)
              .map((item) => PhonesModel.fromJson(item as Map<String, dynamic>))
              .toList();

          final List<PhonesModel> allPhones = [
            ...applePhones,
            ...samsungPhones,
            ...onePlusPhones,
            ...googlePhones
          ];

          log.info("Total phones retrieved: ${allPhones.length}");
          return allPhones;
        } catch (e) {
          log.error("Error while parsing phone data: $e");
          return [];
        }
      });
    } catch (e) {
      log.error("An unexpected error occurred: $e");
      return [];
    }
  }
}
