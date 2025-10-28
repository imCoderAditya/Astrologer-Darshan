import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/services/firebase/firebase_services.dart';
import 'package:astrology/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/core/config/theme/app_theme.dart';
import 'app/core/config/theme/theme_controller.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 await FirebaseServices.firebaseToken();
  FirebaseServices().setupFirebaseForegroundListener();
  // FirebaseLocalHandle().initLocalNotifications();
  
  await GetStorage.init();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryColor,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final ThemeController themeController = Get.put(ThemeController());
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (_, child) {
        return Obx(() {
          final isDark = themeController.isDarkMode.value;
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value:
                isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Atro Darshan",
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
              initialRoute: AppPages.INITIAL,
              getPages: AppPages.routes,
              // home: NavView(),
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.linear(0.8)),
                  child: child ?? const SizedBox.shrink(),
                );
              },
            ),
          );
        });
      },
      child: const Placeholder(),
    );
  }
}
