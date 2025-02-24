import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_project/utility/model_constant.dart';
import 'package:quick_log/quick_log.dart';
import '../../utility/model_result.dart';

class FirebaseAccountAddCardsModel {
  final log = const Logger('FirebaseAccountAddCardsModel');

  Future<Either<Failure, Map<String, dynamic>>> addDataToUserCollection({
    required String uid,
    required Map<String, dynamic> updatedData,
    required String key,
    String? uniqueField,
  }) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;

    try {
      final userDoc = fireStore
          .collection(ModelConstantsCollection.userCollection)
          .doc(uid);
      final currentData = await getCurrentUserData(userDoc, key);

      if (uniqueField != null && updatedData.containsKey(uniqueField)) {
        final uniqueValue = updatedData[uniqueField];
        bool dataExists =
            checkIfDataExists(currentData, uniqueField, uniqueValue);

        if (dataExists) {
          log.warning(
              'An item with $uniqueField = $uniqueValue already exists!');
          return Left(
              Failure('An item with this $uniqueField already exists.'));
        }
      }

      await updateUserData(userDoc, key, currentData, updatedData);
      return Right(updatedData);
    } catch (e) {
      log.error('Failed to update data: $e', includeStackTrace: false);
      return Left(Failure('Failed to update data.'));
    }
  }

  Future<List<Map<String, dynamic>>> getCurrentUserData(
      DocumentReference userDoc, String key) async {
    final userSnapshot = await userDoc.get();
    final data = userSnapshot.data() as Map<String, dynamic>?;
    final dynamicList = data?[key] as List<dynamic>? ?? [];
    return dynamicList
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  bool checkIfDataExists(List<Map<String, dynamic>> currentData,
      String uniqueField, String newValue) {
    return currentData.any((item) => item[uniqueField] == newValue);
  }

  Future<void> updateUserData(
      DocumentReference userDoc,
      String key,
      List<Map<String, dynamic>> currentData,
      Map<String, dynamic> updatedData) async {
    currentData.add(updatedData);
    await userDoc.update({key: currentData});
    log.fine('Updated successfully', includeStackTrace: false);
  }
}
