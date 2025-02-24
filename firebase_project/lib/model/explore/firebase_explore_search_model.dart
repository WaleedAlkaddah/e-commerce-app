import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_project/utility/model_constant.dart';
import 'package:firebase_project/utility/model_result.dart';
import 'package:quick_log/quick_log.dart';

class FirebaseExploreSearchModel {
  final log = const Logger('FirebaseExploreSearchModel');

  Future<Either<Failure, List<dynamic>>> getSearchResultModel({
    required String category,
    required String companyName,
  }) async {
    try {
      final FirebaseFirestore fireStore = FirebaseFirestore.instance;

      DocumentSnapshot docSnapshot = await fireStore
          .collection(ModelConstantsCollection.imageCollection)
          .doc(category)
          .get();

      if (!docSnapshot.exists) {
        log.error("No data found in the category: $category");
        return left(Failure("No data found in the category: $category"));
      }

      Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
      if (data == null || !data.containsKey(category)) {
        log.error("No data available in the category: $category");
        return left(Failure("No data available in the category: $category"));
      }

      Map<String, dynamic> items = data[category];
      String searchQuery = companyName.trim().toLowerCase();
      log.fine("Searching for: $searchQuery");

      for (var key in items.keys) {
        if (key.toLowerCase().contains(searchQuery)) {
          log.info("Match found: ${items[key]}");
          return Right(items[key]);
        }
      }
      log.error("No results found for '$companyName' in '$category'");
      return left(
          Failure("No results found for '$companyName' in '$category'"));
    } catch (e) {
      log.error("Error fetching data: $e");
      return left(Failure("Error fetching data: $e"));
    }
  }
}
