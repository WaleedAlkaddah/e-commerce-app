import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/utility/account_utils.dart';
import 'package:firebase_project/utility/hive_constants.dart';
import 'package:firebase_project/utility/model_constant.dart';
import 'package:quick_log/quick_log.dart';
import '../../utility/hive_preferences_data.dart';
import '../../utility/model_result.dart';
import 'firebase_account_model.dart';

class FirebaseAccountGetUserDataModel {
  final log = const Logger('FirebaseAccountGetUserDataModel');
  final HivePreferencesData hivePreferencesData = HivePreferencesData();
  final dataRead = ["uid", "email", "first_name", "last_name", "image"];

  Future<Either<Failure, FirebaseAccountHomeModel>> getUserDataModel() async {
    try {
      final cachedModel = await getCachedUserData();
      if (cachedModel != null) {
        log.fine('Returning cached user data.');
        return Right(cachedModel);
      }

      return await getUserDataFromFirebase();
    } catch (e) {
      log.error('Error retrieving user data: $e', includeStackTrace: false);
      return Left(Failure('Error retrieving user data: $e'));
    }
  }

  Future<FirebaseAccountHomeModel?> getCachedUserData() async {
    final cachedData = await hivePreferencesData.retrieveHiveData(
      boxName: HiveBoxes.userBox,
      key: HiveKeys.dataUser,
    );

    if (cachedData != null) {
      final castedData = Map<String, dynamic>.from(cachedData);
      return FirebaseAccountHomeModel.fromMap(castedData);
    }
    return null;
  }

  Future<Either<Failure, FirebaseAccountHomeModel>>
      getUserDataFromFirebase() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      log.warning('No user is currently signed in.');
      return Left(Failure('No user is currently signed in.'));
    }

    final uid = currentUser.uid;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection(ModelConstantsCollection.userCollection)
        .doc(uid)
        .get();

    if (!userDoc.exists) {
      log.warning('User data not found!');
      return Left(Failure('User data not found!'));
    }

    final userData = userDoc.data() as Map<String, dynamic>;
    FirebaseAccountHomeModel firebaseAccountModel =
        FirebaseAccountHomeModel.fromMap(userData);

    await storeUserDataInHive(firebaseAccountModel);

    if (userData["address"] != null) {
      await storeUserAddressInHive(userData["address"]);
    }

    if (userData["user_cart"] != null) {
      await AccountHomeUtils()
          .storeUserCartInHive(userData["user_cart"], userData["total_price"]);
    }

    return Right(firebaseAccountModel);
  }

  Future<void> storeUserDataInHive(
      FirebaseAccountHomeModel firebaseAccountModel) async {
    final dataStored = {
      "uid": firebaseAccountModel.uid,
      "first_name": firebaseAccountModel.firstName,
      "last_name": firebaseAccountModel.lastName,
      "email": firebaseAccountModel.email,
      "image": firebaseAccountModel.image,
    };

    await hivePreferencesData.storeHiveData(
      boxName: HiveBoxes.userBox,
      key: HiveKeys.dataUser,
      value: dataStored,
    );
  }

  Future<void> storeUserAddressInHive(Map<String, dynamic> address) async {
    final userAddress = {
      "street": address["street"],
      "locality": address["locality"],
      "postalCode": address["postalCode"],
      "country": address["country"],
      "latitude": address["latitude"],
      "longitude": address["longitude"]
    };

    await HivePreferencesData().storeHiveData(
      boxName: HiveBoxes.addressBox,
      key: HiveKeys.address,
      value: userAddress,
    );
  }
}
