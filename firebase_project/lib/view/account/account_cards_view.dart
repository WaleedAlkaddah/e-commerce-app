import 'package:firebase_project/utility/global_utils.dart';
import 'package:firebase_project/utility/hive_constants.dart';
import 'package:firebase_project/utility/hive_preferences_data.dart';
import 'package:firebase_project/waleedWidget/refresh_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quick_log/quick_log.dart';
import '../../states/account_states/account_cards_states.dart';
import '../../viewModel/account/account_cards_view_model.dart';
import 'account_new_cards_view.dart';

class AccountCardsView extends StatefulWidget {
  final String userId;
  const AccountCardsView({super.key, required this.userId});

  @override
  State<AccountCardsView> createState() => _AccountCardsViewState();
}

class _AccountCardsViewState extends State<AccountCardsView> {
  late final AccountCardsViewModel viewModel;
  final log = const Logger('AccountCardsView');
  int? selectedIndex;

  @override
  void initState() {
    viewModel = context.read<AccountCardsViewModel>();
    viewModel.getCardsDetailsViewModel(
      uid: widget.userId,
      key: "creditCards",
    );
    selectedIndex = viewModel.selectedCardIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xff00C569)),
        ),
        centerTitle: true,
        title: Text(
          "Cards",
          style: GlobalUtils.googleFontsFunction(
            fontSizeText: 20.0.sp,
            fontWeightText: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff00C569),
        tooltip: 'Add Cards',
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: AccountNewEditCardsView(
                userId: widget.userId,
              ),
            ),
          );
        },
        icon: Icon(Icons.add, color: Colors.white, size: 28.sp),
        label: Text(
          "New",
          style: GlobalUtils.googleFontsFunction(colorText: Colors.white),
        ),
      ),
      body: RefreshIndicatorWidget(
        onRefreshCall: () async {
          await viewModel.getCardsDetailsViewModel(
            uid: widget.userId,
            key: "creditCards",
          );
        },
        childWidget: BlocBuilder<AccountCardsViewModel, AccountCardsStates>(
          builder: (context, state) {
            if (state is LoadingAccountCardsStates) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xff00C569),
                ),
              );
            }
            if (state is FailureAccountCardsStates) {
              return Center(
                child: Text(
                  "No New Cards!",
                  style: GlobalUtils.googleFontsFunction(
                    fontSizeText: 16.0.sp,
                  ),
                ),
              );
            }
            if (state is SuccessAccountCardsStates) {
              final creditCards = state.creditCardsModel;
              return SizedBox(
                height: double.infinity,
                child: ListView.builder(
                  itemCount: creditCards.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      child: Card(
                        color: Colors.white,
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Card Holder: ${creditCards[index].cardHolderName}',
                                    style: GlobalUtils.googleFontsFunction(
                                        fontSizeText: 18.0.sp,
                                        fontWeightText: FontWeight.bold,
                                        colorText: Colors.black87),
                                  ),
                                  8.0.verticalSpace,
                                  Text(
                                    'Card Number: ${creditCards[index].cardNumber}',
                                    style: GlobalUtils.googleFontsFunction(
                                        fontSizeText: 16.0.sp,
                                        colorText: Colors.black54),
                                  ),
                                  8.0.verticalSpace,
                                  Text(
                                    'Expiry Date: ${creditCards[index].expiryDate}',
                                    style: GlobalUtils.googleFontsFunction(
                                        fontSizeText: 16.0.sp,
                                        colorText: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 10.0.h,
                              right: 10.0.h,
                              child: Checkbox(
                                activeColor: const Color(0xff00C569),
                                value: selectedIndex == index,
                                onChanged: (bool? value) async {
                                  if (value == true) {
                                    selectedIndex = index;
                                    viewModel.selectedCardIndex = index;

                                    final data = {
                                      "card_holder":
                                          creditCards[index].cardHolderName,
                                      "card_number":
                                          creditCards[index].cardNumber,
                                      "expiry_date":
                                          creditCards[index].expiryDate,
                                      "cvv_code": creditCards[index].cvvCode,
                                    };

                                    setState(() {});

                                    await HivePreferencesData().storeHiveData(
                                      boxName: HiveBoxes.creditCardBox,
                                      key: HiveKeys.creditCard,
                                      value: data,
                                    );
                                  } else {
                                    setState(() {
                                      selectedIndex = null;
                                      viewModel.selectedCardIndex = null;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return Center(
                child: Text(
                  "No New Credit Cards",
                  style: GlobalUtils.googleFontsFunction(
                    fontSizeText: 16.0.sp,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
