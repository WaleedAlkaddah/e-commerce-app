import 'package:firebase_project/utility/check_internet_utils.dart';
import 'package:firebase_project/utility/global_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quick_log/quick_log.dart';
import '../../states/account_states/account_new_cards_states.dart';
import '../../utility/account_utils.dart';
import '../../viewModel/account/account_new_cards_view_model.dart';
import '../../waleedWidget/elevated_button_widget.dart';
import 'account_cards_view.dart';

class AccountNewEditCardsView extends StatefulWidget {
  final String userId;
  const AccountNewEditCardsView({super.key, required this.userId});

  @override
  State<AccountNewEditCardsView> createState() =>
      _AccountNewEditCardsViewState();
}

class _AccountNewEditCardsViewState extends State<AccountNewEditCardsView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AccountCardsUtils accountCardsUtils = AccountCardsUtils();
  final log = const Logger('AccountNewEditCardsView');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    AccountCardsUtils.cardNumberController.clear();
    AccountCardsUtils.expiryDateController.clear();
    AccountCardsUtils.cardHolderNameController.clear();
    AccountCardsUtils.cvvCodeController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountNewEditCardsViewModel =
        context.read<AccountNewCardsViewModel>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        centerTitle: true,
        title: Text(
          'Credit Card Details',
          style: GlobalUtils.googleFontsFunction(
            fontSizeText: 20.0.sp,
            fontWeightText: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xff00C569)),
        ),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              20.0.verticalSpace,
              CreditCardWidget(
                cardNumber: AccountCardsUtils.cardNumberController.text,
                expiryDate: AccountCardsUtils.expiryDateController.text,
                cardHolderName: AccountCardsUtils.cardHolderNameController.text,
                cvvCode: AccountCardsUtils.cvvCodeController.text,
                showBackView: AccountCardsUtils.isCvvFocused,
                obscureCardNumber: false,
                obscureCardCvv: false,
                isHolderNameVisible: true,
                cardBgColor: const Color(0xff00C569),
                isSwipeGestureEnabled: true,
                onCreditCardWidgetChange: (CreditCardBrand brand) {},
              ),
              CreditCardForm(
                formKey: formKey,
                obscureCvv: true,
                obscureNumber: false,
                cardNumber: AccountCardsUtils.cardNumberController.text,
                cvvCode: AccountCardsUtils.cvvCodeController.text,
                isHolderNameVisible: true,
                isCardNumberVisible: true,
                isExpiryDateVisible: true,
                cardHolderName: AccountCardsUtils.cardHolderNameController.text,
                expiryDate: AccountCardsUtils.expiryDateController.text,
                onCreditCardModelChange: onCreditCardModelChange,
                cardNumberDecoration: accountCardsUtils.buildInputDecoration(
                    'Card Number', 'XXXX XXXX XXXX XXXX'),
                expiryDateDecoration: accountCardsUtils.buildInputDecoration(
                    'Expiry Date', 'MM/YY'),
                cvvCodeDecoration:
                    accountCardsUtils.buildInputDecoration('CVV', 'XXX'),
                cardHolderDecoration:
                    accountCardsUtils.buildInputDecoration('Card Holder', ''),
                themeColor: const Color(0xff00C569),
              ),
              BlocListener<AccountNewCardsViewModel, AccountNewEditCardsStates>(
                listener: (context, state) {
                  if (state is LoadingAccountNewEditCardsStates) {
                    EasyLoading.show(status: "Loading ..");
                  } else if (state is SuccessAccountNewEditCardsStates) {
                    EasyLoading.dismiss();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountCardsView(
                          userId: widget.userId,
                        ),
                      ),
                    );
                  } else if (state is FailureAccountNewEditCardsStates) {
                    EasyLoading.showError(state.errorMessage);
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 40.0.h),
                  child: ElevatedButtonWidget(
                    text: "Save",
                    fontSize: 14.0,
                    textColor: Colors.white,
                    elevatedColor: const Color(0xff00C569),
                    elevatedWidth: 311.0,
                    elevatedHeight: 50.0,
                    onPressedCall: () async {
                      await CheckInternetUtils().checkInternetConnection();
                      if (CheckInternetUtils.checkInternet) {
                        if (formKey.currentState?.validate() ?? false) {
                          accountNewEditCardsViewModel.newCardsViewModel(
                              uid: widget.userId, key: "creditCards");
                        } else {
                          log.error("Form in Cards is invalid",
                              includeStackTrace: false);
                        }
                      } else {
                        EasyLoading.showError("Check the Internet first");
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      AccountCardsUtils.cardNumberController.text =
          creditCardModel?.cardNumber ?? '';
      AccountCardsUtils.expiryDateController.text =
          creditCardModel?.expiryDate ?? '';
      AccountCardsUtils.cardHolderNameController.text =
          creditCardModel?.cardHolderName ?? '';
      AccountCardsUtils.cvvCodeController.text = creditCardModel?.cvvCode ?? '';
      AccountCardsUtils.isCvvFocused = creditCardModel?.isCvvFocused ?? false;
    });
  }
}
