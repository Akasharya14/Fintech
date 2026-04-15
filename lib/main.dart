import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'core/router/app_router.dart';
import 'core/controller/auth_controller.dart';
import 'core/controller/theme_controller.dart';
import 'core/controller/dashboard_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Get.putAsync(() => AuthController().init());
  await Get.putAsync(() => ThemeController().init());
  Get.put(DashboardController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetBuilder<ThemeController>(
          init: ThemeController.to,
          builder: (controller) {
            return GetMaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'FinTech App',
              theme: ThemeData(
                brightness: Brightness.light,
                scaffoldBackgroundColor: const Color(0xFFF7F8FC),
                primaryColor: const Color(0xFF1E3A8A),
                fontFamily: 'Roboto',
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: const Color(0xFF121212),
                primaryColor: const Color(0xFF2563EB),
                fontFamily: 'Roboto',
                useMaterial3: true,
              ),
              themeMode: controller.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              routeInformationParser: AppRouter.router.routeInformationParser,
              routerDelegate: AppRouter.router.routerDelegate,
              routeInformationProvider: AppRouter.router.routeInformationProvider,
            );
          },
        );
      },
    );
  }
}
