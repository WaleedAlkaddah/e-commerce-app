import 'package:firebase_project/utility/hive_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_project/utility/signup_signin_utils.dart';
import 'package:quick_log/quick_log.dart';
import 'package:hive/hive.dart';

class HivePreferencesData {
  final log = const Logger('HivePreferencesData');

  Future<Box> openBox(String boxName) async {
    try {
      return await Hive.openBox(boxName);
    } catch (e) {
      log.error("Failed to open box $boxName: $e", includeStackTrace: false);
      rethrow;
    }
  }

  Future<void> closeBox(Box box) async {
    if (box.isOpen) {
      await box.close();
    }
  }

  Future<bool> storeHiveData({
    required String boxName,
    required String key,
    required dynamic value,
  }) async {
    final box = await openBox(boxName);

    try {
      if (boxName == 'cart_box' || boxName == "favorites_box") {
        return await handleCartBoxStorage(box: box, key: key, value: value);
      } else if (value is Map) {
        await box.put(key, value);
        log.fine('Data stored successfully with key: $key : $value');
        return true;
      } else {
        throw ArgumentError('Value must be of type Map');
      }
    } catch (e) {
      log.error("Error while storing data: $e", includeStackTrace: false);
      return false;
    } finally {
      await closeBox(box);
    }
  }

  Future<bool> handleCartBoxStorage({
    required Box box,
    required String key,
    required dynamic value,
  }) async {
    if (value is! Map<String, dynamic>) {
      throw ArgumentError(
          'For cart_box, value must be of type Map<String, dynamic>');
    }
    final existingData =
        await retrieveHiveData(boxName: box.name, key: key, box: box) ?? [];
    if (existingData.any((item) => item['name'] == value['name'])) {
      log.warning("Duplicate $value");
      return false;
    }
    existingData.add(value);
    await box.put(key, existingData);
    log.fine('Data stored successfully with key: $key : $value');
    return true;
  }

  Future<dynamic> retrieveHiveData({
    required String boxName,
    required String key,
    Box? box,
  }) async {
    // if Box is Passed that mean the box is Already Opened
    final isBoxOpenedLocally = box == null;
    box ??= await openBox(boxName);

    try {
      return box.get(key);
    } catch (e) {
      log.error("Error while retrieving data: $e", includeStackTrace: false);
      return null;
    } finally {
      // if not OpenedLocally so the function that called this function will close the box.
      if (isBoxOpenedLocally) {
        await closeBox(box);
      }
    }
  }

  void initializeHivePreferences() async {
    try {
      final dataStored = await retrieveHiveData(
          boxName: HiveBoxes.singInBox, key: HiveKeys.dataLogin);
      if (dataStored.isNotEmpty) {
        String? email = dataStored['email_login'];
        String? password = dataStored['password_login'];
        WelcomeViewUtils.emailController.text = email ?? '';
        WelcomeViewUtils.passwordController.text = password ?? '';
        log.fine("Preferences initialized successfully.");
      } else {
        log.warning("No data found for key data_login.");
      }
    } catch (e) {
      log.warning("initialize preferences: $e", includeStackTrace: false);
    }
  }

  Future<void> deleteFromHive({
    required String boxName,
    required String key,
    String? nameToDelete,
  }) async {
    final box = await openBox(boxName);

    try {
      if (nameToDelete == null) {
        log.info('Contents of $boxName before deletion: ${box.toMap()}');
        if (box.containsKey(key)) {
          await box.delete(key);
          log.fine('Item with key $key deleted from box $boxName.');
        } else {
          log.warning('Key $key not found in box $boxName.');
        }
        log.info('Contents of $boxName after deletion: ${box.toMap()}');
      } else {
        await handleDeleteByName(
            box: box, key: key, nameToDelete: nameToDelete);
      }
    } catch (e) {
      log.error('Error deleting item from Hive: $e', includeStackTrace: false);
    } finally {
      await closeBox(box);
    }
  }

  Future<bool> handleDeleteByName(
      {required Box box,
      required String key,
      required String nameToDelete}) async {
    final data = box.get(key);
    if (data is List) {
      final updatedData = data
          .where((item) => item is Map && item['name'] != nameToDelete)
          .toList();
      await box.put(key, updatedData);
      log.fine(
          'Items with name $nameToDelete removed from $key in ${box.name}.');
      return true;
    } else {
      log.warning('Data under key $key is not in the expected format.');
      return false;
    }
  }

  Future<void> updateHiveData({
    required String boxName,
    required String key,
    required String itemName,
    required Map<String, dynamic> updatedData,
  }) async {
    final box = await openBox(boxName);

    try {
      List<dynamic> data = await retrieveHiveData(
            boxName: boxName,
            key: key,
            box: box,
          ) ??
          [];
      var item = data.firstWhere((item) => item['name'] == itemName,
          orElse: () => null);
      if (item != null) {
        item.addAll(updatedData);
      }
      log.info("Full updated data: $data");
      await box.put(key, data);
      log.fine('Data updated successfully for item: $itemName');
    } catch (e) {
      log.error('Error while updating data: $e', includeStackTrace: false);
    } finally {
      await closeBox(box);
    }
  }
}
