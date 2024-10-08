import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/services/local_notification_service.dart';
import 'package:chat_app/theme/theme_controller.dart';
import 'package:chat_app/views/auth/auth_manage.dart';
import 'package:chat_app/views/auth/components/sign_in.dart';
import 'package:chat_app/views/auth/components/sign_up.dart';
import 'package:chat_app/views/home/chat_page.dart';
import 'package:chat_app/views/home/home_page.dart';
import 'package:chat_app/views/home/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeController = Get.put(ThemeController());
  await themeController.loadTheme();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  tz.initializeTimeZones();
  await LocalNotificationService.notificationService.initNotificationService();
  runApp(const MyApp());
}

final ThemeController themeController = Get.put(ThemeController());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeController.isDarkMode.value
              ? ThemeData.dark()
              : ThemeData.light(),
          getPages: [
            GetPage(
              name: '/',
              page: () => const SplashScreen(),
            ),
            GetPage(
              name: '/auth',
              page: () => const AuthManage(),
            ),
            GetPage(
              name: '/signIn',
              page: () => const SignIn(),
            ),
            GetPage(
              name: '/signUp',
              page: () => const SignUp(),
            ),
            GetPage(
              name: '/home',
              page: () => const HomePage(),
            ),
            GetPage(
              name: '/chat',
              page: () => const ChatPage(),
            ),
          ],
        );
      },
    );
  }
}

// 11:58
