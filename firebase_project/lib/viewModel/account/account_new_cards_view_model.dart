import 'package:firebase_project/utility/account_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_log/quick_log.dart';
import '../../model/account/firebase_account_add_cards_model.dart';
import '../../states/account_states/account_new_cards_states.dart';

class AccountNewCardsViewModel extends Cubit<AccountNewEditCardsStates> {
  AccountNewCardsViewModel() : super(InitialAccountNewEditCardsStates());
  final log = const Logger('AccountNewEditCardsViewModel');

  void newCardsViewModel({required String uid, required String key}) async {
    emit(LoadingAccountNewEditCardsStates());
    final model = FirebaseAccountAddCardsModel();
    final newEditCards = {
      "card_number": AccountCardsUtils.cardNumberController.text,
      "expiry_date": AccountCardsUtils.expiryDateController.text,
      "card_holder_name": AccountCardsUtils.cardHolderNameController.text,
      "cvv_code": AccountCardsUtils.cvvCodeController.text,
    };
    final checkModel = await model.addDataToUserCollection(
      uid: uid,
      updatedData: newEditCards,
      key: key,
      uniqueField: "card_number",
    );
    checkModel.fold((failure) {
      log.error("Update user data failed : ${failure.message}",
          includeStackTrace: false);
      emit(FailureAccountNewEditCardsStates(failure.message));
    }, (data) {
      log.fine("Update User Data $data", includeStackTrace: false);
      emit(SuccessAccountNewEditCardsStates());
    });
  }
}
