import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/modules/splash_screen/splash_screen.dart';
import 'package:poultry/app/modules/splash_screen/splash_scren_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();

  // Only initialize FlutterDownloader for mobile platforms
  if (!kIsWeb) {
    await FlutterDownloader.initialize();
  }

  // Initialize Firebase based on platform
  await initializeFirebase();

  // Check login status
  final storage = GetStorage();
  final adminData = await storage.read('admin_uid');
  log("Admin uid : $adminData");
  Get.put(LoginController());

  runApp(const MyApp());
}

Future<void> initializeFirebase() async {
  if (kIsWeb) {
    // Web Firebase configuration
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyB2TQCkMxvrz88d8vy1Ppkc3uXyoaeskKY",
          authDomain: "poultry-c0903.firebaseapp.com",
          projectId: "poultry-c0903",
          storageBucket: "poultry-c0903.firebasestorage.app",
          messagingSenderId: "375240465625",
          appId: "1:375240465625:web:28e5fdcf3c51c45174f2c8"),
    );
  } else if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBb1QbfrCc_R8ehquYog7ZGgA_cY985xx4",
          appId: "1:375240465625:android:2fa0fb0854bcfda274f2c8",
          messagingSenderId: "375240465625",
          projectId: "poultry-c0903",
          storageBucket: "poultry-c0903.firebasestorage.app"),
    );
  } else {
    await Firebase.initializeApp();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Poultry Manager',
          theme: ThemeData(
            primaryColor: AppColors.primaryColor,
            fontFamily: 'notoSansDevanagari',
            dialogTheme: const DialogTheme(
              elevation: 0,
            ),
            buttonBarTheme: const ButtonBarThemeData(),
            indicatorColor: AppColors.primaryColor,
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(
                  primary: AppColors.primaryColor,
                  secondary: AppColors.secondaryColor,
                )
                .copyWith(background: Colors.white),
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(
                color: Colors.white, // Ensures app bar icons are white
              ),
              titleTextStyle: TextStyle(
                color: Colors.white, // Ensures app bar title is white
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              actionsIconTheme: IconThemeData(
                color: Colors.white, // Ensures app bar action icons are white
              ),
              backgroundColor:
                  AppColors.primaryColor, // App bar background color
            ),
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
