import 'package:firebase_project/states/signin_states/signin_google_states.dart';
import 'package:firebase_project/states/signin_states/signin_states.dart';
import 'package:firebase_project/utility/check_internet_utils.dart';
import 'package:firebase_project/utility/hive_preferences_data.dart';
import 'package:firebase_project/viewModel/signin/signin_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quick_log/quick_log.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toastification/toastification.dart';
import '../../../assetsPath/assets_path.dart';
import '../../../navigation_bar_app.dart';
import '../../../states/signin_states/signin_forget_password_states.dart';
import '../../../utility/global_utils.dart';
import '../../../utility/signup_signin_utils.dart';
import '../../../viewModel/signin/forget_password_view_model.dart';
import '../../../viewModel/signin/signin_google_view_model.dart';
import '../../../waleedWidget/elevated_button_icon_widget.dart';
import '../../../waleedWidget/elevated_button_widget.dart';
import '../../../waleedWidget/text_form_filed_widget.dart';
import '../signup/signup_view.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  final WelcomeViewUtils welcomeViewUtils = WelcomeViewUtils();
  final ValidateText validateText = ValidateText();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final log = const Logger('WelcomeView');
  final HivePreferencesData hivePreferencesData = HivePreferencesData();

  @override
  void initState() {
    super.initState();
    getRememberMe();
  }

  getRememberMe() async {
    hivePreferencesData.initializeHivePreferences();
  }

  @override
  Widget build(BuildContext context) {
    final signInViewModel = context.read<SignInViewModel>();
    final signInGoogleViewModel = context.read<SignInGoogleViewModel>();
    final forgetPasswordViewModel = context.read<ForgetPasswordViewModel>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                margin:
                    EdgeInsets.only(right: 16.0.w, left: 16.0.w, top: 126.0.h),
                width: 1.0.sw,
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(10.0).r,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 14.0.h, bottom: 10.0.h, right: 73.5.w),
                              child: Text(
                                "Welcome,",
                                style: GlobalUtils.googleFontsFunction(
                                    fontSizeText: 30.0.sp,
                                    fontWeightText: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: 14.0.h,
                              left: 20.0.w,
                            ),
                            child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                        child: SignupView()),
                                  );
                                },
                                child: Text(
                                  "Sign Up",
                                  style: GlobalUtils.googleFontsFunction(
                                      fontSizeText: 18.0.sp,
                                      fontWeightText: FontWeight.bold,
                                      colorText: Color(0xff00C569)),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          bottom: 48.0.h, right: 156.5.w, left: 16.0.w),
                      width: 171.5.w,
                      height: 22.0.h,
                      child: Text(
                        "Sign in to Continue",
                        style: GlobalUtils.googleFontsFunction(
                            fontSizeText: 14.0.sp,
                            colorText: Color(0xff929292)),
                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 16.0.w),
                            child: TextFormFiledWidget(
                              widthFiled: 312.0,
                              heightFiled: 70.0,
                              labelFiled: "Email",
                              labelSizeFont: 14.0,
                              widthLabel: 33.0,
                              heightLabel: 19.0,
                              controller: WelcomeViewUtils.emailController,
                              textInputType: TextInputType.emailAddress,
                              validator: (value) =>
                                  validateText.validateEmail(value),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: 10.0.h,
                                bottom: 5.0.h,
                                right: 16.0.w,
                                left: 16.0.w),
                            child: TextFormFiledWidget(
                              widthFiled: 312.0,
                              heightFiled: 70.0,
                              labelFiled: "Password",
                              labelSizeFont: 14.0,
                              widthLabel: 58.0,
                              heightLabel: 19.0,
                              controller: WelcomeViewUtils.passwordController,
                              textInputType: TextInputType.text,
                              obscurePassword: true,
                              validator: (value) =>
                                  validateText.validatePassword(value),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(bottom: 10.0.h, left: 5.0.w),
                            child: Row(
                              children: [
                                Checkbox(
                                  activeColor: const Color(0xff00C569),
                                  value: WelcomeViewUtils.isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      welcomeViewUtils.checkRemember(value!);
                                    });
                                  },
                                ),
                                Text(
                                  'Remember me',
                                  style: GlobalUtils.googleFontsFunction(
                                    fontSizeText: 14.0.sp,
                                  ),
                                ),
                                BlocListener<ForgetPasswordViewModel,
                                    SignInForgetPasswordStates>(
                                  listener: (context, states) {
                                    if (states
                                        is LoadingSignInForgetPasswordStates) {
                                      EasyLoading.show(status: "Loading");
                                    } else if (states
                                        is SuccessSignInForgetPasswordStates) {
                                      GlobalUtils().showCustomSnackBar(
                                          type: ToastificationType.error,
                                          message:
                                              "Please check your email to resent your password",
                                          title: "Forget Password");
                                      EasyLoading.dismiss();
                                    } else if (states
                                        is FailureSignInForgetPasswordStates) {
                                      EasyLoading.showError(
                                          states.errorMessage);
                                      EasyLoading.dismiss();
                                    }
                                  },
                                  child: InkWell(
                                    onTap: () async {
                                      await CheckInternetUtils()
                                          .checkInternetConnection();
                                      if (CheckInternetUtils.checkInternet) {
                                        WelcomeViewUtils
                                            .emailForgetPasswordController
                                            .clear();
                                        if (!context.mounted) return;
                                        GlobalUtils().showDialog(
                                          context: context,
                                          onConfirm: () => forgetPasswordViewModel
                                              .forgetPasswordResetViewModel(),
                                          alertType: AlertType.none,
                                          bodyWidget:
                                              buildForgetPasswordDialog(),
                                        );
                                      } else {
                                        EasyLoading.showError(
                                            "Check the Internet first");
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 60.0.w),
                                      child: Text(
                                        "Forgot Password?",
                                        style: GlobalUtils.googleFontsFunction(
                                            fontSizeText: 13.0.sp,
                                            colorText: Color(0xff00C569)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          BlocListener<SignInViewModel, SignInStates>(
                            listener: (context, state) {
                              if (state is LoadingSignInStates) {
                                EasyLoading.show(
                                  status: 'Loading..',
                                );
                              } else if (state is SuccessSignInStates) {
                                Navigator.of(context).pushReplacement(
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                      child: NavigationBarApp(
                                        index: 0,
                                      )),
                                );

                                EasyLoading.dismiss();
                              } else if (state is FailureSignInStates) {
                                EasyLoading.showError(
                                    "Email or Password Incorrect!");
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 16.0.w, right: 16.0.w, bottom: 16.0.h),
                              child: ElevatedButtonWidget(
                                text: 'Sign In',
                                fontSize: 14.0,
                                textColor: Colors.white,
                                elevatedColor: const Color(0xff00C569),
                                elevatedWidth: 311.0,
                                elevatedHeight: 50.0,
                                onPressedCall: () async {
                                  await CheckInternetUtils()
                                      .checkInternetConnection();
                                  if (CheckInternetUtils.checkInternet ==
                                      true) {
                                    if (formKey.currentState?.validate() ??
                                        false) {
                                      signInViewModel.searchUserViewModel();
                                    } else {
                                      log.error("Form in SignIn is invalid",
                                          includeStackTrace: false);
                                    }
                                  } else {
                                    EasyLoading.showError(
                                        "Check the Internet first");
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 28.0.h, bottom: 43.0.h),
                child: Center(
                  child: Text(
                    "-OR-",
                    style: TextStyle(
                        fontFamily: 'SFProDisplay', fontSize: 18.0.sp),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0.w),
                child: ElevatedButtonIconWidget(
                    text: 'Sign In with Facebook',
                    fontSize: 14.0,
                    textColor: Colors.black,
                    elevatedColor: Colors.white,
                    elevatedWidth: 343.0,
                    elevatedHeight: 50.0,
                    onPressedCall: () {},
                    borderColor: const Color(0xffDDDDDD),
                    svgPath: AssetsPath.facebookLogo,
                    svgWidth: 20.0,
                    svgHeight: 19.0,
                    isEnabled: false,
                    spaceBetweenIcon: 53.0,
                    spaceBetweenText: 40.0),
              ),
              BlocListener<SignInGoogleViewModel, SignInGoogleStates>(
                listener: (context, state) {
                  if (state is LoadingSignInGoogleStates) {
                    EasyLoading.show(
                      status: 'Loading..',
                    );
                  } else if (state is SuccessSignInGoogleStates) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const NavigationBarApp(
                              index: 0,
                            )));
                    EasyLoading.dismiss();
                  } else if (state is FailureSignInGoogleStates) {
                    EasyLoading.showError(state.errorMessage);
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 10.0.h, horizontal: 15.0.w),
                  child: ElevatedButtonIconWidget(
                    text: 'Sign In with Google',
                    fontSize: 14.0,
                    textColor: Colors.black,
                    elevatedColor: Colors.white,
                    elevatedWidth: 343.0,
                    elevatedHeight: 50.0,
                    onPressedCall: () async {
                      await CheckInternetUtils().checkInternetConnection();
                      if (CheckInternetUtils.checkInternet) {
                        signInGoogleViewModel.signInWithGoogle();
                      } else {
                        EasyLoading.showError("Check the Internet first");
                      }
                    },
                    borderColor: const Color(0xffDDDDDD),
                    svgPath: AssetsPath.googleLogo,
                    svgWidth: 20.0,
                    svgHeight: 20.0,
                    spaceBetweenIcon: 55.0,
                    spaceBetweenText: 45.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildForgetPasswordDialog() {
    return Center(
      child: Column(
        children: [
          Text(
            "Forget Password",
            style: GlobalUtils.googleFontsFunction(
                fontSizeText: 20.0.sp, fontWeightText: FontWeight.bold),
          ),
          15.0.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0.w),
            child: TextFormFiledWidget(
              widthFiled: 312.0,
              heightFiled: 70.0,
              labelFiled: "Email",
              widthLabel: 33.0,
              fontWeightType: FontWeight.bold,
              heightLabel: 19.0,
              labelSizeFont: 14.0,
              controller: WelcomeViewUtils.emailForgetPasswordController,
              textInputType: TextInputType.emailAddress,
              validator: (value) => validateText.validateEmail(value),
            ),
          ),
        ],
      ),
    );
  }
}
