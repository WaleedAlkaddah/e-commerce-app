import 'package:firebase_project/utility/model_constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_log/quick_log.dart';
import '../../model/account/firebase_account_update_address_model.dart';
import '../../states/account_states/account_shipping_address_states.dart';
import '../../utility/account_utils.dart';

class AccountShippingAddressViewModel
    extends Cubit<AccountShippingAddressStates> {
  AccountShippingAddressViewModel()
      : super(InitialAccountShippingAddressStates());
  final log = const Logger('AccountShippingAddressViewModel');
  AccountShippingAddressUtils accountShippingAddressUtils =
      AccountShippingAddressUtils();

  void getUserLocationViewModel({required String uid}) async {
    emit(LoadingAccountShippingAddressStates());

    final checkUserLocation =
        await accountShippingAddressUtils.getUserLocationUtils();

    if (checkUserLocation != null) {
      final model = FirebaseAccountUpdateAddressModel();
      final checkModel = await model.updateAddressModel(
          uid: uid,
          updatedData: checkUserLocation,
          key: "address",
          collectionName: ModelConstantsCollection.userCollection);
      checkModel.fold(
        (failure) {
          log.error("Update user data failed: ${failure.message}",
              includeStackTrace: false);
          emit(FailureAccountShippingAddressStates(failure.message));
        },
        (successMessage) {
          log.fine(successMessage, includeStackTrace: false);
          emit(SuccessAccountShippingAddressStates());
        },
      );
    } else {
      log.error("Error getting location or address", includeStackTrace: false);
      emit(FailureAccountShippingAddressStates("Permission Denied"));
    }
  }
}
