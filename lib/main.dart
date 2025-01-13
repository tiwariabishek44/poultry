// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:poultry/appss/widget/poultryLogin/poultryLoginController.dart';
// import 'package:poultry/appss/widget/splashScreen/poultrySplashScreen.dart';

// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:flutter/services.dart';

// import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'package:open_file/open_file.dart';
// import 'package:share_plus/share_plus.dart';

// void main() async {
//   await GetStorage.init();
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Firebase
//   Platform.isAndroid
//       ? await Firebase.initializeApp(
//           options: const FirebaseOptions(
//               apiKey: "AIzaSyBb1QbfrCc_R8ehquYog7ZGgA_cY985xx4",
//               appId: "1:375240465625:android:2fa0fb0854bcfda274f2c8",
//               messagingSenderId: "375240465625",
//               projectId: "poultry-c0903",
//               storageBucket: "poultry-c0903.firebasestorage.app"))
//       : await Firebase.initializeApp();
//   Get.put(PoultryLoginController());
//   // Configure the system navigation bar color
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       systemNavigationBarColor:
//           Color.fromARGB(255, 158, 157, 157), // Dark color for visibility
//       systemNavigationBarIconBrightness: Brightness.light, // White icons
//       statusBarColor:
//           Color.fromARGB(0, 148, 146, 146), // Transparent status bar
//       statusBarIconBrightness: Brightness.dark, // Dark status bar icons
//     ),
//   );

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     FocusScope.of(context).unfocus(); // Close the keyboard

//     return ResponsiveSizer(
//       builder: (context, orientation, screenType) {
//         return GetMaterialApp(
//           title: 'poultry',
//           debugShowCheckedModeBanner: false,
//           theme: ThemeData(
//             primarySwatch: Colors.green, // Change primary color to green
//             fontFamily: 'notoSansDevanagari',
//             appBarTheme: AppBarTheme(
//               iconTheme: IconThemeData(
//                 color: Colors.white, // Ensures app bar icons are white
//               ),
//               titleTextStyle: TextStyle(
//                 color: Colors.white, // Ensures app bar title is white
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.bold,
//               ),
//               backgroundColor:
//                   const Color(0xFF2563EB), // Green background for app bar
//             ),

//             pageTransitionsTheme: PageTransitionsTheme(
//               builders: {
//                 TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
//               },
//             ),
//           ),
//           home: PoultrySplashScreen(),
//         );
//       },
//     );
//   }
// }

import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
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
  await FlutterDownloader.initialize();

  // Initialize Firebase
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyBb1QbfrCc_R8ehquYog7ZGgA_cY985xx4",
              appId: "1:375240465625:android:2fa0fb0854bcfda274f2c8",
              messagingSenderId: "375240465625",
              projectId: "poultry-c0903",
              storageBucket: "poultry-c0903.firebasestorage.app"))
      : await Firebase.initializeApp();

  // Check login status
  final storage = GetStorage();
  final adminData = await storage.read('admin_uid');
  log("Admin uid : $adminData");
  Get.put(LoginController());

  runApp(const MyApp());
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
