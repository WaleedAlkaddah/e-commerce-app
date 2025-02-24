import 'package:connectivity_plus/connectivity_plus.dart';

class CheckInternetUtils {
  static bool checkInternet = false;

  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    checkInternet = connectivityResult != ConnectivityResult.none;
  }
}
