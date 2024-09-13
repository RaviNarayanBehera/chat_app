import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/views/auth/auth_manage.dart';
import 'package:chat_app/views/auth/components/sign_in.dart';
import 'package:chat_app/views/auth/components/sign_up.dart';
import 'package:chat_app/views/home/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main()
async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(name: '/', page: () => const AuthManage(),),
        GetPage(name: '/signIn', page: () => const SignIn(),),
        GetPage(name: '/signUp', page: () => const SignUp(),),
        GetPage(name: '/home', page: () => const HomePage(),),
      ],
    );
  }
}
