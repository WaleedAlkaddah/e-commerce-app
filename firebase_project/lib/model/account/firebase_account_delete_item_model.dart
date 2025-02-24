import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_project/utility/model_constant.dart';
import 'package:firebase_project/utility/model_result.dart';
import 'package:quick_log/quick_log.dart';

class FirebaseAccountDeleteItemModel {
  final log = const Logger('FirebaseAccountDeleteItemModel');

  Future<Either<Failure, String>> deleteItemModel({
    required String uid,
    required String key,
  }) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;

    try {
      final userDoc = fireStore
          .collection(ModelConstantsCollection.userCollection)
          .doc(uid);

      final userSnapshot = await userDoc.get();
      if (!userSnapshot.exists) {
        log.error('User document does not exist: $uid',
            includeStackTrace: false);
        return Left(Failure('User document does not exist.'));
      }

      await userDoc.update({
        key: FieldValue.delete(),
      });

      log.fine('$key deleted successfully', includeStackTrace: false);
      return Right('$key deleted successfully');
    } catch (e) {
      log.error('Failed to delete $key: $e', includeStackTrace: false);
      return Left(Failure('Failed to delete $key: $e'));
    }
  }
}
