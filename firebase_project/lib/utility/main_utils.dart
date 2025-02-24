import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/viewModel/checkout/checkout_view_model.dart';
import 'package:firebase_project/viewModel/explore/explore_get_home_view_model.dart';
import 'package:firebase_project/viewModel/explore/explore_search_view_model.dart';
import 'package:firebase_project/viewModel/account/account_address_view_model.dart';
import 'package:firebase_project/viewModel/account/account_cards_view_model.dart';
import 'package:firebase_project/viewModel/account/account_change_password_view_model.dart';
import 'package:firebase_project/viewModel/account/account_edit_profile_view_model.dart';
import 'package:firebase_project/viewModel/account/account_home_view_model.dart';
import 'package:firebase_project/viewModel/account/account_new_cards_view_model.dart';
import 'package:firebase_project/viewModel/account/account_shipping_address_view_model.dart';
import 'package:firebase_project/viewModel/cart/cart_count_view_model.dart';
import 'package:firebase_project/viewModel/cart/cart_total_view_model.dart';
import 'package:firebase_project/viewModel/explore/explore_add_reviews_view_model.dart';
import 'package:firebase_project/viewModel/explore/explore_get_reviews_view_model.dart';
import 'package:firebase_project/viewModel/explore/explore_get_shoes_view_model.dart';
import 'package:firebase_project/viewModel/signin/forget_password_view_model.dart';
import 'package:firebase_project/viewModel/signin/signin_google_view_model.dart';
import 'package:firebase_project/viewModel/signin/signin_view_model.dart';
import 'package:firebase_project/viewModel/signup/signup_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_log/quick_log.dart';

class MainUtils {
  final log = const Logger('MainUtils');
  static get blocProviders => [
        BlocProvider(create: (_) => SignInViewModel()),
        BlocProvider(create: (_) => SignupViewModel()),
        BlocProvider(create: (_) => SignInGoogleViewModel()),
        BlocProvider(create: (_) => AccountEditProfileViewModel()),
        BlocProvider(create: (_) => AccountChangePasswordViewModel()),
        BlocProvider(create: (_) => ForgetPasswordViewModel()),
        BlocProvider(create: (_) => AccountHomeViewModel()),
        BlocProvider(create: (_) => AccountShippingAddressViewModel()),
        BlocProvider(create: (_) => AccountNewCardsViewModel()),
        BlocProvider(create: (_) => AccountCardsViewModel()),
        BlocProvider(create: (_) => AccountAddressViewModel()),
        BlocProvider(create: (_) => ExploreGetShoesViewModel()),
        BlocProvider(create: (_) => ExploreAddReviewsViewModel()),
        BlocProvider(create: (_) => ExploreGetReviewsViewModel()),
        BlocProvider(create: (_) => CartCountViewModel()),
        BlocProvider(create: (_) => CartTotalViewModel()),
        BlocProvider(create: (_) => CheckoutViewModel()),
        BlocProvider(create: (_) => ExploreGetHomeViewModel()),
        BlocProvider(create: (_) => ExploreSearchViewModel()),
      ];

  void checkSignIn() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        log.info('User is currently signed out!', includeStackTrace: false);
      } else {
        log.info('User is signed in!', includeStackTrace: false);
        log.info('User ID: ${user.uid}', includeStackTrace: false);
        log.info('User Email: ${user.email}', includeStackTrace: false);
      }
    });
  }
}
