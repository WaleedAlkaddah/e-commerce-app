import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_project/utility/model_constant.dart';
import 'package:firebase_project/utility/model_result.dart';
import 'package:quick_log/quick_log.dart';

class FirebaseCheckoutUpdateModel {
  final log = const Logger('FirebaseCheckoutUpdateModel');

  Future<Either<Failure, String>> updateShoeModel(String brand,
      String productName, Map<String, dynamic> newData, String docId) async {
    try {
      var productDoc = FirebaseFirestore.instance
          .collection(ModelConstantsCollection.imageCollection)
          .doc(docId);

      var snapshot = await productDoc.get();

      if (!snapshot.exists) {
        log.error('Document not found!');
        return left(Failure('Document not found!'));
      }

      var productData = snapshot.data();

      if (productData?[docId]?[brand] == null) {
        log.error('Brand not found!');
        return left(Failure('Brand not found!'));
      }

      List productList = List.from(productData![docId][brand]);

      int index = productList.indexWhere((shoe) => shoe['name'] == productName);

      if (index == -1) {
        log.error('Product not found!');
        return left(Failure("Product not found!"));
      }

      productList[index] = {...productList[index], ...newData};

      await productDoc.update({'$docId.$brand': productList});
      log.fine('Product updated successfully!');
      return Right('Product updated: $productName');
    } catch (e) {
      return left(Failure('An error occurred during the update: $e'));
    }
  }
}
