import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_project/services/awesome_notifications_services.dart';
import 'package:firebase_project/firebase_options.dart';
import 'package:firebase_project/utility/global_utils.dart';
import 'package:firebase_project/utility/main_utils.dart';
import 'package:firebase_project/view/signup-Login/signin/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quick_log/quick_log.dart';
import 'package:toastification/toastification.dart';
import 'navigation_bar_app.dart';

void main() async {
  final log = const Logger('Main');

  WidgetsFlutterBinding.ensureInitialized();
  await initializeServices(log);

  runApp(const MyApp());
}

Future<void> initializeServices(Logger log) async {
  log.info("Initializing services...");

  await Hive.initFlutter();
  AwesomeNotificationsServices().awesomeNotificationsInitialize();
  await initializeFirebase(log);
  configureFirestore();

  log.fine("All services initialized.");
}

Future<void> initializeFirebase(Logger log) async {
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    log.fine("Firebase initialized.");
  } catch (e) {
    log.error("Failed to initialize Firebase $e");
  }
}

void configureFirestore() {
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final MainUtils mainUtils = MainUtils();
  final log = const Logger('MyApp');

  @override
  void initState() {
    mainUtils.checkSignIn();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GlobalUtils.easyLoadingFunction();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375.0, 812.0),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: ToastificationWrapper(
            child: MultiBlocProvider(
              providers: MainUtils.blocProviders,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                navigatorKey: GlobalUtils.navigatorKey,
                theme:
                    ThemeData(scaffoldBackgroundColor: const Color(0xFFFFFFFF)),
                title: 'Shopping',
                home: (FirebaseAuth.instance.currentUser != null &&
                        FirebaseAuth.instance.currentUser!.emailVerified)
                    ? const NavigationBarApp(
                        index: 0,
                      )
                    : const WelcomeView(),
                builder: EasyLoading.init(),
              ),
            ),
          ),
        );
      },
    );
  }
}
