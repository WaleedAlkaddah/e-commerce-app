import 'package:firebase_project/utility/hive_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_log/quick_log.dart';
import '../../model/account/firebase_account_edit_profile_model.dart';
import '../../states/account_states/account_edit_profile_states.dart';
import '../../utility/hive_preferences_data.dart';

class AccountEditProfileViewModel extends Cubit<AccountEditProfileStates> {
  AccountEditProfileViewModel() : super(InitialAccountEditProfileStates());
  final log = const Logger('AccountEditProfileViewModel');
  Map<String, String> updateDataUser = {};
  final HivePreferencesData hivePreferencesData = HivePreferencesData();

  void updateUserDataViewModel({
    required String uid,
    required String firstName,
    required String lastName,
  }) async {
    emit(LoadingAccountEditProfileStates());
    final model = FirebaseAccountEditProfileModel();
    final imageFile = await hivePreferencesData.retrieveHiveData(
        boxName: HiveBoxes.imagePathBox, key: HiveKeys.imagePath);
    if (imageFile == null) {
      updateDataUser = {
        "first_name": firstName,
        "last_name": lastName,
        "image": "",
      };
      log.info(updateDataUser, includeStackTrace: false);
    } else {
      final imageUrl = await uploadImageAndGetUrlViewModel(imageFile["image"]);
      updateDataUser = {
        "first_name": firstName,
        "last_name": lastName,
        "image": imageUrl,
      };
      log.info("updateDataUser: $updateDataUser", includeStackTrace: false);
    }

    final checkModel =
        await model.updateUserDataModel(uid: uid, updatedData: updateDataUser);

    checkModel.fold(
      (failure) {
        log.error("Update Failed: ${failure.message}",
            includeStackTrace: false);
        emit(FailureAccountEditProfileStates(failure.message));
      },
      (successMessage) {
        log.fine("Updated User Data: $successMessage",
            includeStackTrace: false);
        emit(SuccessAccountEditProfileStates());
      },
    );
  }

  Future<String> uploadImageAndGetUrlViewModel(String imageFile) async {
    log.info("uploadImageAndGetUrlViewModel with $imageFile",
        includeStackTrace: false);

    final model = FirebaseAccountEditProfileModel();
    final checkModel = await model.uploadImageAndGetUrlModel(imageFile);

    return checkModel.fold((failure) {
      log.error("Image upload failed $failure", includeStackTrace: false);
      return "Error Uploading Image";
    }, (data) {
      log.fine("Image uploaded successfully. URL: $data",
          includeStackTrace: false);
      return data;
    });
  }
}
