import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_project/utility/model_result.dart';
import 'package:quick_log/quick_log.dart';

class FirebaseAccountUpdateAddressModel {
  final log = const Logger('FirebaseAccountUpdateAddressModel');

  Future<Either<Failure, String>> updateAddressModel({
    required String uid,
    required Map<String, dynamic> updatedData,
    required String collectionName,
    required String key,
  }) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    try {
      final userDoc = await fireStore.collection(collectionName).doc(uid).get();
      if (!userDoc.exists) {
        log.warning('Document with uid: $uid does not exist.');
        return Left(Failure('Document with uid: $uid does not exist.'));
      }

      await fireStore.collection(collectionName).doc(uid).update({
        key: updatedData,
      });

      log.fine('Updated successfully!', includeStackTrace: false);
      return const Right('Updated successfully!');
    } catch (e) {
      log.error('Failed to Update : $e', includeStackTrace: false);
      return Left(Failure('Failed to update the data: $e'));
    }
  }
}
