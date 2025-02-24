import 'package:firebase_project/waleedWidget/refresh_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quick_log/quick_log.dart';
import '../../states/account_states/account_address_states.dart';
import '../../states/account_states/account_shipping_address_states.dart';
import '../../utility/global_utils.dart';
import '../../viewModel/account/account_address_view_model.dart';
import '../../viewModel/account/account_shipping_address_view_model.dart';

class AccountShippingAddress extends StatefulWidget {
  final String userId;
  const AccountShippingAddress({
    super.key,
    required this.userId,
  });

  @override
  State<AccountShippingAddress> createState() => _AccountShippingAddressState();
}

class _AccountShippingAddressState extends State<AccountShippingAddress> {
  late final AccountShippingAddressViewModel accountShippingAddressViewModel;
  late final AccountAddressViewModel accountAddressViewModel;
  final GlobalUtils globalUtils = GlobalUtils();
  final log = const Logger('AccountShippingAddress');
  bool haveLocation = false;
  @override
  void initState() {
    super.initState();

    accountAddressViewModel = context.read<AccountAddressViewModel>();
    accountAddressViewModel.getUserAddressViewModel(
        uid: widget.userId, key: "address");

    accountShippingAddressViewModel =
        context.read<AccountShippingAddressViewModel>();
  }

  Future<void> handleAddAddress() async {
    try {
      final status = await Permission.location.status;

      if (status.isGranted) {
        await fetchUserLocation();
      } else if (status.isDenied) {
        await handleDeniedPermission();
      } else if (status.isPermanentlyDenied) {
        handlePermanentlyDeniedPermission();
      }
    } catch (e) {
      log.error("Error in handleAddAddress: $e", includeStackTrace: true);
      EasyLoading.showError("An unexpected error occurred. Please try again.");
    }
  }

  Future<void> fetchUserLocation() async {
    accountShippingAddressViewModel.getUserLocationViewModel(
        uid: widget.userId);
    haveLocation = true;
    log.info("User location fetched successfully.", includeStackTrace: false);
  }

  Future<void> handleDeniedPermission() async {
    final isPermissionGranted =
        await globalUtils.requestStoragePermission(Permission.location);

    if (isPermissionGranted) {
      await fetchUserLocation();
    } else {
      log.info("Permission denied by user.", includeStackTrace: false);
      EasyLoading.showError("Permission Denied!");
    }
  }

  void handlePermanentlyDeniedPermission() {
    log.info("Permission permanently denied", includeStackTrace: false);
    EasyLoading.showError(
        "Permission denied permanently! Please enable it from settings.");
    openAppSettings();
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
          "Shipping Address",
          style: GlobalUtils.googleFontsFunction(
              fontWeightText: FontWeight.bold,
              fontSizeText: 20.0.sp,
              colorText: Colors.black),
        ),
      ),
      floatingActionButton: BlocListener<AccountShippingAddressViewModel,
          AccountShippingAddressStates>(
        listener: (context, state) {
          if (state is LoadingAccountShippingAddressStates) {
            EasyLoading.show(status: 'Fetching your location...');
          } else if (state is SuccessAccountShippingAddressStates) {
            accountAddressViewModel.getUserAddressViewModel(
                uid: widget.userId, key: "address");
            EasyLoading.dismiss();
          } else if (state is FailureAccountShippingAddressStates) {
            EasyLoading.dismiss();
            EasyLoading.showError(state.errorMessage);
          }
        },
        child: FloatingActionButton(
          backgroundColor: const Color(0xff00C569),
          tooltip: 'Add Address',
          onPressed: handleAddAddress,
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
      body: buildBodyContent(),
    );
  }

  Widget buildBodyContent() {
    return RefreshIndicatorWidget(
      onRefreshCall: () async {
        await accountAddressViewModel.getUserAddressViewModel(
            uid: widget.userId, key: "address");
      },
      childWidget: BlocBuilder<AccountAddressViewModel, AccountAddressStates>(
        builder: (context, state) {
          if (state is LoadingAccountAddressStates) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xff00C569),
              ),
            );
          } else if (state is SuccessAccountAddressStates) {
            final address = state.addressModel;
            return ListView(
              padding: EdgeInsets.only(top: 35.0.h, left: 15.0.w),
              children: [
                Text(
                  address.locality,
                  style: GlobalUtils.googleFontsFunction(
                      fontWeightText: FontWeight.bold,
                      fontSizeText: 20.0.sp,
                      colorText: Colors.black87),
                ),
                4.0.verticalSpace,
                Text(
                  address.street,
                  style: GlobalUtils.googleFontsFunction(
                      fontWeightText: FontWeight.bold,
                      fontSizeText: 15.0.sp,
                      colorText: Colors.grey[700]),
                ),
                4.0.verticalSpace,
                Text(
                  address.country,
                  style: GlobalUtils.googleFontsFunction(
                      fontWeightText: FontWeight.bold,
                      fontSizeText: 15.0.sp,
                      colorText: Colors.grey[700]),
                ),
                4.0.verticalSpace,
                Text(
                  address.postalCode,
                  style: GlobalUtils.googleFontsFunction(
                      fontWeightText: FontWeight.bold,
                      fontSizeText: 15.0.sp,
                      colorText: Colors.grey[700]),
                ),
              ],
            );
          } else if (state is FailureAccountAddressStates) {
            return const Center(
              child: Text("No New Address"),
            );
          } else {
            return Center(
              child: Text(
                "No Address",
                style: GlobalUtils.googleFontsFunction(
                  fontSizeText: 16.0.sp,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
