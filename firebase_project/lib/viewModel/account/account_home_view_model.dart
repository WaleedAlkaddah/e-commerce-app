import 'package:firebase_project/states/account_states/account_home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_log/quick_log.dart';

import '../../model/account/firebase_account_get_user_data_model.dart';

class AccountHomeViewModel extends Cubit<AccountHomeStates> {
  AccountHomeViewModel() : super(InitialAccountHomeStates());
  final log = const Logger('AccountHomeViewModel');
  void getUserDataViewModel() async {
    emit(LoadingAccountHomeStates());
    final model = FirebaseAccountGetUserDataModel();
    final checkModel = await model.getUserDataModel();
    checkModel.fold((failure) {
      log.error(failure.message, includeStackTrace: false);
      emit(FailureAccountHomeStates(failure.message));
    }, (data) {
      log.fine(data, includeStackTrace: false);
      emit(SuccessAccountHomeStates(data));
    });
  }
}
