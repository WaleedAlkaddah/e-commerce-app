import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_log/quick_log.dart';
import '../../model/account/firebase_account_address_and_credit_model.dart';
import '../../model/account/firebase_account_model.dart';
import '../../states/account_states/account_address_states.dart';

class AccountAddressViewModel extends Cubit<AccountAddressStates> {
  AccountAddressViewModel() : super(InitialAccountAddressStates());
  final log = const Logger('AccountAddressViewModel');

  Future<void> getUserAddressViewModel(
      {required String uid, required String key}) async {
    emit(LoadingAccountAddressStates());
    final model = FirebaseAccountAddressAndCreditModel();
    final checkModel = await model.getDataWithKeyModel<AddressModel>(
      uid: uid,
      key: key,
      fromMap: (map) => AddressModel.fromMap(map),
    );
    checkModel.fold((failure) {
      log.info("Failed Address Data ${failure.message}",
          includeStackTrace: false);
      emit(FailureAccountAddressStates(failure.message));
    }, (data) {
      log.fine("Get Address Data : $data", includeStackTrace: false);
      emit(SuccessAccountAddressStates(data));
    });
  }
}
