import 'package:firebase_project/model/signin/firebase_google_signin_model.dart';
import 'package:firebase_project/states/signin_states/signin_google_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_log/quick_log.dart';

class SignInGoogleViewModel extends Cubit<SignInGoogleStates> {
  SignInGoogleViewModel() : super(InitialSignInGoogleStates());
  final log = const Logger('SignInGoogleViewModel');

  void signInWithGoogle() async {
    emit(LoadingSignInGoogleStates());
    final model = FirebaseGoogleSignInModel();
    final checkModel = await model.signInWithGoogle();
    checkModel.fold((failure) {
      log.error("An error occurred during Google Sign-In: ${failure.message}",
          includeStackTrace: false);
      emit(FailureSignInGoogleStates(failure.message));
    }, (data) {
      log.fine("Google Sign-In succeeded", includeStackTrace: false);
      emit(SuccessSignInGoogleStates());
    });
  }
}
