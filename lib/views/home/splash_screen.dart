import 'dart:async';

import 'package:chat_app/views/auth/auth_manage.dart';
import 'package:chat_app/views/auth/components/sign_in.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthManage()));
    });
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff1ffbbb),
              Color(0xff61fbf1),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // CircleAvatar(
              //   radius: 100,
              //   backgroundImage: AssetImage('assets/images/logo.png'),
              //
              // ),
              Container(
                height: 500,
                width: 500,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/logo.png'))
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
