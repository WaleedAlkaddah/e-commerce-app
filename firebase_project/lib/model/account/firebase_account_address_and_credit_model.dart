import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_project/utility/model_constant.dart';
import 'package:quick_log/quick_log.dart';
import '../../utility/model_result.dart';

class FirebaseAccountAddressAndCreditModel {
  final log = const Logger('FirebaseAccountAddressModel');

  Future<Either<Failure, T>> getDataWithKeyModel<T>({
    required String uid,
    required String key,
    required T Function(dynamic) fromMap,
  }) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;

    try {
      final userDoc = fireStore
          .collection(ModelConstantsCollection.userCollection)
          .doc(uid);
      final userSnapshot = await userDoc.get();

      if (!userSnapshot.exists) {
        log.error('User document does not exist!', includeStackTrace: false);
        return Left(Failure('User document does not exist'));
      }

      final dynamic data = userSnapshot.data()?[key];
      if (data == null) {
        log.info('No data found for key: $key', includeStackTrace: false);
        return Left(Failure('No data found for key: $key'));
      }

      log.info('Data received: $data');
      log.info(data is Map<String, dynamic>);
      if (data is List) {
        return Right(fromMap(data));
      } else if (data is Map<String, dynamic>) {
        return Right(fromMap(data));
      } else {
        log.error('Unexpected data type for key: $key');
        return Left(Failure('Unexpected data type for key: $key'));
      }
    } catch (e) {
      log.error('Failed to retrieve data: $e', includeStackTrace: true);
      return Left(Failure('Failed to retrieve data: $e'));
    }
  }
}
