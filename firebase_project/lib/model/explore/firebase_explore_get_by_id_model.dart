import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_project/utility/model_result.dart';
import 'package:quick_log/quick_log.dart';

class FirebaseExploreGetById {
  final log = const Logger('FirebaseExploreGetById');

  Future<Either<Failure, Map<String, dynamic>>> getFieldFromFireStoreModel({
    required String collectionName,
    required String docId,
  }) async {
    var fireStore = FirebaseFirestore.instance;

    try {
      DocumentSnapshot documentSnapshot =
          await fireStore.collection(collectionName).doc(docId).get();

      if (!documentSnapshot.exists) {
        log.warning('No document found in $collectionName/$docId.');
        return left(Failure('No document found in $collectionName/$docId.'));
      }

      final data = documentSnapshot.data() as Map<String, dynamic>?;

      if (data == null) {
        log.warning('No data found in $collectionName/$docId.');

        return left(Failure("No data found in $collectionName/$docId."));
      }

      return Right(data);
    } catch (e) {
      log.error("Failed to fetch data: $e");
      return left(Failure("Failed to fetch data: $e"));
    }
  }
}
