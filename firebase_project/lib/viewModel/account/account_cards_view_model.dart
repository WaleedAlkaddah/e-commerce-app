import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_log/quick_log.dart';
import '../../model/account/firebase_account_address_and_credit_model.dart';
import '../../model/account/firebase_account_model.dart';
import '../../states/account_states/account_cards_states.dart';

class AccountCardsViewModel extends Cubit<AccountCardsStates> {
  AccountCardsViewModel() : super(InitialAccountCardsStates());
  final log = const Logger('AccountCardsViewModel');
  int? selectedCardIndex;

  Future<void> getCardsDetailsViewModel(
      {required String uid, required String key}) async {
    emit(LoadingAccountCardsStates());
    final model = FirebaseAccountAddressAndCreditModel();

    final checkModel = await model.getDataWithKeyModel<List<CreditCardsModel>>(
      uid: uid,
      key: key,
      fromMap: (mapList) => (mapList as List)
          .map((item) => CreditCardsModel.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
    checkModel.fold((failure) {
      log.error("Failed get Details ${failure.message}",
          includeStackTrace: false);
      emit(FailureAccountCardsStates(failure.message));
    }, (data) {
      log.fine("Success get Details $data", includeStackTrace: false);
      emit(SuccessAccountCardsStates(data));
    });
  }
}
