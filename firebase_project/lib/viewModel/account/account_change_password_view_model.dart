import 'package:firebase_project/states/account_states/account_change_password_states.dart';
import 'package:firebase_project/utility/account_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_log/quick_log.dart';
import '../../model/account/firebase_change_password_model.dart';

class AccountChangePasswordViewModel
    extends Cubit<AccountChangePasswordStates> {
  AccountChangePasswordViewModel()
      : super(InitialAccountChangePasswordStates());
  final log = const Logger('AccountChangePasswordViewModel');

  void updateUserViewModel() async {
    emit(LoadingAccountChangePasswordStates());
    final model = FirebaseChangePasswordModel();
    final checkModel = await model.updatePasswordModel(
        newPassword: AccountEditProfileUtils.newPasswordController.text,
        oldPassword: AccountEditProfileUtils.oldPasswordController.text);
    checkModel.fold((failure) {
      log.error("Updated Password Failed ${failure.message}",
          includeStackTrace: false);
      emit(FailureAccountChangePasswordStates(failure.message));
    }, (data) {
      log.fine("Updated Password", includeStackTrace: false);
      emit(SuccessAccountChangePasswordStates());
    });
  }
}
