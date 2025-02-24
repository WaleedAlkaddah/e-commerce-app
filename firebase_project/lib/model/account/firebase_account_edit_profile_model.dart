import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_project/utility/hive_constants.dart';
import 'package:firebase_project/utility/hive_preferences_data.dart';
import 'package:firebase_project/utility/model_constant.dart';
import 'package:firebase_project/utility/model_result.dart';
import 'package:quick_log/quick_log.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class FirebaseAccountEditProfileModel {
  final log = const Logger('FirebaseAccountEditProfileModel');
  final HivePreferencesData hivePreferencesData = HivePreferencesData();

  Future<Either<Failure, String>> uploadImageAndGetUrlModel(
      String imageFilePath) async {
    log.info("Uploading image: $imageFilePath", includeStackTrace: false);
    try {
      File file = File(imageFilePath);

      if (!file.existsSync()) {
        log.error("File does not exist: $imageFilePath");
        return Left(Failure("File does not exist: $imageFilePath"));
      }

      final storageRef = FirebaseStorage.instance.ref();
      String fileName = path.basename(imageFilePath);
      final imageRef = storageRef.child('profileImages/$fileName');

      await imageRef.putFile(file);
      String downloadUrl = await imageRef.getDownloadURL();

      log.fine("Download URL: $downloadUrl");
      return Right(downloadUrl);
    } on FirebaseException catch (e) {
      log.error('Firebase error while uploading image: ${e.message}');
      return Left(Failure('Firebase error: ${e.message}'));
    } catch (e) {
      log.error('Unknown error uploading image: $e');
      return Left(Failure('Unknown error: $e'));
    }
  }

  Future<Either<Failure, String>> updateUserDataModel({
    required String uid,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      log.info("Updating user data: $updatedData", includeStackTrace: false);

      final userRef = FirebaseFirestore.instance
          .collection(ModelConstantsCollection.userCollection)
          .doc(uid);

      final userSnapshot = await userRef.get();
      if (!userSnapshot.exists) {
        log.error("User not found: $uid");
        return Left(Failure("User not found: $uid"));
      }

      await userRef.update(updatedData);

      if (!updatedData.containsKey("notifications_token")) {
        await hivePreferencesData.deleteFromHive(
            key: HiveKeys.dataUser, boxName: HiveBoxes.userBox);
        log.fine('User data updated and cache cleared.',
            includeStackTrace: false);
      }

      return Right('User data updated successfully.');
    } on FirebaseException catch (e) {
      log.error('Firebase error while updating user data: ${e.message}');
      return Left(Failure('Firebase error: ${e.message}'));
    } catch (e) {
      log.error('Unknown error updating user data: $e');
      return Left(Failure('Unknown error: $e'));
    }
  }
}
