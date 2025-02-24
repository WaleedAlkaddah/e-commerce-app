import 'package:firebase_project/states/account_states/account_change_password_states.dart';
import 'package:firebase_project/states/account_states/account_edit_profile_states.dart';
import 'package:firebase_project/utility/check_internet_utils.dart';
import 'package:firebase_project/utility/global_utils.dart';
import 'package:firebase_project/utility/hive_constants.dart';
import 'package:firebase_project/utility/hive_preferences_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quick_log/quick_log.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../navigation_bar_app.dart';
import '../../utility/account_utils.dart';
import '../../utility/signup_signin_utils.dart';
import '../../viewModel/account/account_change_password_view_model.dart';
import '../../viewModel/account/account_edit_profile_view_model.dart';
import '../../viewModel/signin/forget_password_view_model.dart';
import '../../waleedWidget/cached_network_widget.dart';
import '../../waleedWidget/elevated_button_widget.dart';
import '../../waleedWidget/text_form_filed_widget.dart';
import 'dart:io';

class AccountEditProfileView extends StatefulWidget {
  final String userUid;
  final String userFirstName;
  final String userLastName;
  final String userEmail;
  final String userImage;
  const AccountEditProfileView(
      {super.key,
      required this.userUid,
      required this.userFirstName,
      required this.userLastName,
      required this.userEmail,
      required this.userImage});

  @override
  State<AccountEditProfileView> createState() => _AccountEditProfileViewState();
}

class _AccountEditProfileViewState extends State<AccountEditProfileView> {
  final ValidateText validateText = ValidateText();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late AccountChangePasswordViewModel accountChangePasswordViewModel;
  late ForgetPasswordViewModel forgetPasswordViewModel;
  final GlobalUtils globalUtils = GlobalUtils();
  final log = const Logger('AccountEditProfileView');
  late bool checkSignIn;
  String? imagePath;
  bool userHasChosenFile = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      accountChangePasswordViewModel =
          context.read<AccountChangePasswordViewModel>();
      forgetPasswordViewModel = context.read<ForgetPasswordViewModel>();
    });

    AccountEditProfileUtils.firstNameController = TextEditingController(
      text: widget.userFirstName,
    );

    AccountEditProfileUtils.lastNameController = TextEditingController(
      text: widget.userLastName,
    );
    AccountEditProfileUtils.emailController = TextEditingController(
      text: widget.userEmail,
    );
  }

  Future<void> updateImage() async {
    final path = await AccountEditProfileUtils().pickImageUtils();
    if (path != null) {
      setState(() {
        imagePath = path;
        userHasChosenFile = true;
      });
    } else {
      log.info("No image was selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountEditProfileViewModel =
        context.read<AccountEditProfileViewModel>();

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () async {
            Navigator.pop(context);
            await HivePreferencesData().deleteFromHive(
                boxName: HiveBoxes.imagePathBox, key: HiveKeys.imagePath);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xff00C569)),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 18.0.w, top: 10.0.h),
                  child: Text(
                    "Edit Profile",
                    style: GlobalUtils.googleFontsFunction(
                      fontSizeText: 30.0.sp,
                      fontWeightText: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30.0.h, top: 30.0.h),
                child: Stack(
                  children: [
                    displayImage(),
                    Positioned(
                      right: 1.0.w,
                      bottom: 10.0.h,
                      child: InkWell(
                        onTap: () {
                          updateImage();
                        },
                        child: Icon(
                          Icons.change_circle_sharp,
                          size: 40.0.w,
                          color: const Color(0xff00C569),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0.h),
                      child: TextFormFiledWidget(
                        widthFiled: 312.0,
                        heightFiled: 70.0,
                        labelFiled: "First Name",
                        widthLabel: 37.0,
                        heightLabel: 19.0,
                        labelSizeFont: 14.0,
                        fontWeightType: FontWeight.bold,
                        controller: AccountEditProfileUtils.firstNameController,
                        textInputType: TextInputType.text,
                        validator: (value) => validateText.validateName(
                            value ?? '', 'First Name'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0.h),
                      child: TextFormFiledWidget(
                        widthFiled: 312.0,
                        heightFiled: 70.0,
                        labelFiled: "Last Name",
                        widthLabel: 37.0,
                        heightLabel: 19.0,
                        labelSizeFont: 14.0,
                        fontWeightType: FontWeight.bold,
                        controller: AccountEditProfileUtils.lastNameController,
                        textInputType: TextInputType.text,
                        validator: (value) =>
                            validateText.validateName(value ?? '', 'Last Name'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0.h),
                      child: Opacity(
                        opacity: 0.5,
                        child: IgnorePointer(
                          child: TextFormFiledWidget(
                            widthFiled: 312.0,
                            heightFiled: 70.0,
                            labelFiled: "Email",
                            widthLabel: 33.0,
                            heightLabel: 19.0,
                            labelSizeFont: 14.0,
                            fontWeightType: FontWeight.bold,
                            controller: AccountEditProfileUtils.emailController,
                            textInputType: TextInputType.emailAddress,
                            validator: (value) =>
                                validateText.validateEmail(value),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButtonWidget(
                      text: "Cancel",
                      fontSize: 14.0,
                      textColor: Colors.black,
                      elevatedColor: Colors.white,
                      elevatedWidth: 150.0,
                      elevatedHeight: 50.0,
                      borderColor: const Color(0xff00C569),
                      elevatedBorderRadius: BorderRadius.circular(15.0).r,
                      onPressedCall: () => Navigator.pop(context),
                    ),
                    BlocListener<AccountEditProfileViewModel,
                        AccountEditProfileStates>(
                      listener: (context, state) {
                        if (state is LoadingAccountEditProfileStates) {
                          EasyLoading.show(status: "Loading ...");
                        } else if (state is SuccessAccountEditProfileStates) {
                          EasyLoading.dismiss();
                          // Data is called back in NavigationBarApp in initState()
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NavigationBarApp(index: 2)),
                          );
                        } else if (state is FailureAccountEditProfileStates) {
                          EasyLoading.showError(state.errorMessage);
                        }
                      },
                      child: ElevatedButtonWidget(
                        text: "Save",
                        fontSize: 14.0,
                        textColor: Colors.white,
                        elevatedColor: const Color(0xff00C569),
                        elevatedWidth: 150.0,
                        elevatedHeight: 50.0,
                        elevatedBorderRadius: BorderRadius.circular(15.0).r,
                        onPressedCall: () async {
                          await CheckInternetUtils().checkInternetConnection();
                          if (CheckInternetUtils.checkInternet) {
                            if (formKey.currentState?.validate() ?? false) {
                              // Image uploaded in ViewModel
                              accountEditProfileViewModel
                                  .updateUserDataViewModel(
                                uid: widget.userUid,
                                firstName: AccountEditProfileUtils
                                    .firstNameController.text,
                                lastName: AccountEditProfileUtils
                                    .lastNameController.text,
                              );
                            } else {
                              log.error("Form in SignUp is invalid",
                                  includeStackTrace: false);
                            }
                          } else {
                            EasyLoading.showError("Check the Internet first");
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              10.0.verticalSpace,
              BlocListener<AccountChangePasswordViewModel,
                  AccountChangePasswordStates>(
                listener: (context, state) {
                  if (state is LoadingAccountChangePasswordStates) {
                    EasyLoading.show(status: "Loading ...");
                  } else if (state is SuccessAccountChangePasswordStates) {
                    EasyLoading.showSuccess("Success");
                    EasyLoading.dismiss();
                  } else if (state is FailureAccountChangePasswordStates) {
                    EasyLoading.showError(state.errorMessage);
                    EasyLoading.dismiss();
                  }
                },
                child: ElevatedButtonWidget(
                  text: 'Change Password',
                  fontSize: 14.0,
                  textColor: Colors.white,
                  elevatedColor: const Color(0xff00C569),
                  elevatedWidth: 311.0,
                  elevatedHeight: 50.0,
                  elevatedBorderRadius: BorderRadius.circular(15.0).r,
                  onPressedCall: () async {
                    await CheckInternetUtils().checkInternetConnection();
                    if (CheckInternetUtils.checkInternet) {
                      if (!context.mounted) return;
                      changePasswordDialog(context);
                    } else {
                      EasyLoading.showError("Check the Internet first");
                    }
                  },
                ),
              ),
              10.0.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget displayImage() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Color(0xff00C569), width: 4.0.w),
      ),
      padding: EdgeInsets.all(4.0).r,
      child: ClipOval(
        child: buildImage(),
      ),
    );
  }

  Widget buildImage() {
    if (widget.userImage.isNotEmpty &&
        !userHasChosenFile &&
        widget.userImage != "Error Uploading Image") {
      return CachedNetworkWidget(
        imageHeight: 150.0.h,
        imageWidth: 150.0.w,
        imageFit: BoxFit.cover,
        imageUrl: widget.userImage,
      );
    } else if (userHasChosenFile && imagePath != null) {
      return Image.file(
        File(imagePath!),
        width: 150.w,
        height: 150.h,
        fit: BoxFit.cover,
      );
    } else {
      return CachedNetworkWidget(
        imageHeight: 150.0.h,
        imageWidth: 150.0.w,
        imageFit: BoxFit.cover,
        imageUrl: "https://avatar.iran.liara.run/public/boy?username=Ash",
      );
    }
  }

  void changePasswordDialog(BuildContext context) {
    AccountEditProfileUtils.newPasswordController.text = "";
    AccountEditProfileUtils.oldPasswordController.text = "";

    globalUtils.showDialog(
      context: context,
      onConfirm: () {
        accountChangePasswordViewModel.updateUserViewModel();
      },
      alertType: AlertType.none,
      bodyWidget: buildChangePasswordUI(),
    );
  }

  Widget buildChangePasswordUI() {
    return Center(
      child: Column(
        children: [
          Text(
            "Change Password",
            style: GlobalUtils.googleFontsFunction(
              fontSizeText: 20.0.sp,
              fontWeightText: FontWeight.bold,
            ),
          ),
          15.0.verticalSpace,
          buildPasswordField("Current Password",
              AccountEditProfileUtils.oldPasswordController),
          buildForgotPasswordButton(),
          buildPasswordField(
              "New Password", AccountEditProfileUtils.newPasswordController),
        ],
      ),
    );
  }

  Widget buildPasswordField(String label, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0.w),
      child: TextFormFiledWidget(
        widthFiled: 312.0,
        heightFiled: 70.0,
        labelFiled: label,
        widthLabel: 33.0,
        fontWeightType: FontWeight.bold,
        heightLabel: 19.0,
        labelSizeFont: 14.0,
        controller: controller,
        textInputType: TextInputType.text,
        obscurePassword: true,
        validator: (value) => validateText.validatePassword(value),
      ),
    );
  }

  Widget buildForgotPasswordButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: showForgotPasswordDialog,
          child: Container(
            margin: EdgeInsets.only(right: 15.0.w),
            child: Text(
              "Forgot Password?",
              style: GlobalUtils.googleFontsFunction(
                  fontSizeText: 13.0.sp,
                  fontWeightText: FontWeight.bold,
                  colorText: Color(0xff00C569)),
            ),
          ),
        ),
      ],
    );
  }

  void showForgotPasswordDialog() {
    WelcomeViewUtils.emailForgetPasswordController.text = "";

    globalUtils.showDialog(
      context: context,
      onConfirm: () {
        forgetPasswordViewModel.forgetPasswordResetViewModel();
      },
      alertType: AlertType.none,
      bodyWidget: buildForgotPasswordUI(),
    );
  }

  Widget buildForgotPasswordUI() {
    return Center(
      child: Column(
        children: [
          Text(
            "Forget Password",
            style: GlobalUtils.googleFontsFunction(
              fontSizeText: 20.0.sp,
              fontWeightText: FontWeight.bold,
            ),
          ),
          15.0.verticalSpace,
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0.w),
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
