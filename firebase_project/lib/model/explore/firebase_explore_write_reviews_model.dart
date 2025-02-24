import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_project/utility/hive_constants.dart';
import 'package:firebase_project/utility/hive_preferences_data.dart';
import 'package:firebase_project/utility/model_result.dart';
import 'package:quick_log/quick_log.dart';

class FirebaseExploreWriteReviewsModel {
  final log = const Logger('FirebaseExploreWriteReviewsModel');
  final HivePreferencesData hivePreferencesData = HivePreferencesData();

  Future<Either<Failure, String>> addReviewsModel({
    required String userReview,
    required double userRating,
    required String productName,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        log.warning("User is not logged in");
        return Left(Failure("User is not logged in"));
      }

      final userData = await hivePreferencesData.retrieveHiveData(
        boxName: HiveBoxes.userBox,
        key: HiveKeys.dataUser,
      );

      if (userData == null ||
          !userData.containsKey("uid") ||
          !userData.containsKey("first_name") ||
          !userData.containsKey("last_name") ||
          !userData.containsKey("image")) {
        log.error("User data is missing from Hive");
        return Left(Failure("User data is incomplete"));
      }

      String uid = userData["uid"];
      String firstName = userData["first_name"];
      String lastName = userData["last_name"];
      String userImage = userData["image"];

      String fullName =
          (firstName == lastName) ? firstName : "$firstName $lastName";

      DateTime now = DateTime.now();
      String formattedTime = "${now.hour}:${now.minute}:${now.second}";
      String formattedDate = "${now.year}/${now.month}/${now.day}";

      DatabaseReference ref =
          FirebaseDatabase.instance.ref("reviews/$productName");

      await ref.push().set({
        "uid": uid,
        "user_name": fullName,
        "user_review": userReview,
        "user_rating": userRating,
        "user_image": userImage,
        "timestamp": formattedTime,
        "date": formattedDate
      });

      log.info("Review added successfully for user: $uid");
      return Right("Review added successfully with user ID: $uid");
    } catch (e) {
      log.error("Error adding review: $e");
      return Left(Failure("Failed to add review: $e"));
    }
  }
}
