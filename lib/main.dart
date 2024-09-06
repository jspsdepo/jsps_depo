import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsps_depo/firebase_options.dart';
import 'package:jsps_depo/firebase_storage/local_storage_service.dart';
import 'package:jsps_depo/firebase_storage/storage_service.dart';
import 'package:jsps_depo/login_screen/pages/recover_password_page.dart';
import 'package:jsps_depo/login_screen/pages/registration_page.dart';
import 'package:jsps_depo/pages/adli_kolluk/adli_kolluk_controller.dart';
import 'package:jsps_depo/pages/home_screen/screens/home_screen.dart';
import 'package:jsps_depo/pages/jsps_konular/folder_controller.dart';
import 'package:jsps_depo/pages/quiz_app/quiz_controller.dart';
import 'package:jsps_depo/services/auth_service.dart';
import 'package:jsps_depo/themes/custom_dark_theme.dart';
import 'package:jsps_depo/themes/custom_light_theme.dart';
import 'package:jsps_depo/themes/theme_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  final prefs = await SharedPreferences.getInstance();
  Get.put(AuthService());
  final themeNotifier = ThemeNotifier();
  await themeNotifier.loadThemePreference(); // Tema tercihini yükle
  Get.put(themeNotifier);
  Get.put<LocalStorageService>(LocalStorageService(prefs));
  Get.put<StorageService>(StorageService());
  Get.put<QuizController>(QuizController());
  Get.put<AdliKollukController>(AdliKollukController());
  Get.put<FolderController>(FolderController());
  runApp(const MyApp());
}

class AuthStateWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();

    return StreamBuilder<User?>(
      stream: authService.userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data!.emailVerified) {
          return const HomeScreen();
        } else {
          return RegistrationPage();
        }
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Get.find<ThemeNotifier>();

    return Obx(
      () => GetMaterialApp(
        theme: CustomLightTheme().themeData,
        darkTheme: CustomDarkTheme().themeData,
        themeMode: themeNotifier.themeMode,
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => AuthStateWrapper()),
          GetPage(name: '/home', page: () => const HomeScreen()),
          GetPage(
            name: '/recover_password',
            page: () => RecoverPasswordPage(),
          ),
        ],
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
