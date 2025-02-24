import 'package:firebase_project/utility/check_internet_utils.dart';
import 'package:firebase_project/viewModel/signup/signup_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quick_log/quick_log.dart';
import 'package:toastification/toastification.dart';
import '../../../states/signup_states/signup_states.dart';
import '../../../utility/global_utils.dart';
import '../../../utility/signup_signin_utils.dart';
import '../../../waleedWidget/elevated_button_widget.dart';
import '../../../waleedWidget/text_form_filed_widget.dart';
import '../signin/welcome_view.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final WelcomeViewUtils welcomeViewUtils = WelcomeViewUtils();
  final SignupViewModel signupViewModel = SignupViewModel();
  final ValidateText validateText = ValidateText();
  final log = const Logger('SignupView');
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalUtils globalFunctions = GlobalUtils();

  @override
  void initState() {
    SignupUtils.firstNameController.clear();
    SignupUtils.lastNameController.clear();
    SignupUtils.emailController.clear();
    SignupUtils.passwordController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final signupViewModel = context.read<SignupViewModel>();
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
              80.0.verticalSpace,
              Container(
                margin:
                    EdgeInsets.only(right: 15.0.w, left: 15.0.w, top: 32.0.h),
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 16.0.w, top: 11.0.h, bottom: 47.0.h),
                        child: Text(
                          "Sign Up",
                          style: GlobalUtils.googleFontsFunction(
                              fontSizeText: 30.0.sp,
                              fontWeightText: FontWeight.bold),
                        ),
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
                              labelFiled: "First Name",
                              widthLabel: 37.0,
                              heightLabel: 19.0,
                              labelSizeFont: 14.0,
                              controller: SignupUtils.firstNameController,
                              textInputType: TextInputType.text,
                              validator: (value) => validateText.validateName(
                                  value ?? '', 'First Name'),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: 20.0.h, left: 16.0.w, right: 16.0.w),
                            child: TextFormFiledWidget(
                              widthFiled: 312.0,
                              heightFiled: 70.0,
                              labelFiled: "Last Name",
                              widthLabel: 37.0,
                              heightLabel: 19.0,
                              labelSizeFont: 14.0,
                              controller: SignupUtils.lastNameController,
                              textInputType: TextInputType.text,
                              validator: (value) => validateText.validateName(
                                  value ?? '', 'Last Name'),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 20.0.h, horizontal: 16.0.w),
                            child: TextFormFiledWidget(
                              widthFiled: 312.0,
                              heightFiled: 70.0,
                              labelFiled: "Email",
                              widthLabel: 33.0,
                              heightLabel: 19.0,
                              labelSizeFont: 14.0,
                              controller: SignupUtils.emailController,
                              textInputType: TextInputType.emailAddress,
                              validator: (value) =>
                                  validateText.validateEmail(value),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 16.0.w),
                            child: TextFormFiledWidget(
                              widthFiled: 312.0,
                              heightFiled: 70.0,
                              labelFiled: "Password",
                              widthLabel: 58.0,
                              heightLabel: 19.0,
                              labelSizeFont: 14.0,
                              controller: SignupUtils.passwordController,
                              textInputType: TextInputType.text,
                              obscurePassword: true,
                              validator: (value) =>
                                  validateText.validatePassword(value),
                            ),
                          ),
                          10.0.verticalSpace,
                          BlocListener<SignupViewModel, SignupStates>(
                            listener: (context, state) {
                              if (state is LoadingSignupState) {
                                EasyLoading.show(
                                  status: 'Loading..',
                                );
                              } else if (state is SuccessSignupState) {
                                EasyLoading.dismiss();
                                GlobalUtils().showCustomSnackBar(
                                    type: ToastificationType.success,
                                    message:
                                        "Please check your email to verify your account.",
                                    title: "Verification");
                                Navigator.of(context).pushReplacement(
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                      child: WelcomeView()),
                                );
                              } else if (state is FailureSignupState) {
                                EasyLoading.showError(state.errorMessage);
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 16.0.w, right: 17.0.w, bottom: 20.0.h),
                              child: ElevatedButtonWidget(
                                text: "SIGN UP",
                                fontSize: 14.0,
                                textColor: Colors.white,
                                elevatedColor: const Color(0xff00C569),
                                elevatedWidth: 311.0,
                                elevatedHeight: 50.0,
                                onPressedCall: () async {
                                  await CheckInternetUtils()
                                      .checkInternetConnection();
                                  if (CheckInternetUtils.checkInternet) {
                                    if (formKey.currentState?.validate() ??
                                        false) {
                                      signupViewModel.addUserViewModel();
                                    } else {
                                      log.error("Form in SignUp is invalid",
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
              25.0.verticalSpace,
              Container(
                margin: EdgeInsets.only(bottom: 16.0.h),
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'Already have an account ? ',
                      style: GlobalUtils.googleFontsFunction(
                        fontSizeText: 13.0.sp,
                      ),
                      children: [
                        TextSpan(
                          text: "Log in",
                          style: GlobalUtils.googleFontsFunction(
                              fontSizeText: 13.0.sp,
                              fontWeightText: FontWeight.bold,
                              colorText: Colors.green),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    child: WelcomeView()),
                              );
                            },
                        )
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
