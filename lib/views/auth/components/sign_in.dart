import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/google_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign In',
          style: TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff61fbf1), Color(0xff61fbf1)],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff1ffbbb), Color(0xff61fbf1)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: AlertDialog(
          shadowColor: Colors.black,
          backgroundColor: const Color(0xff27f2bc),
          title: const Center(child: Text('Welcome Back',style: TextStyle(color: Colors.black),)),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller.txtEmail,
                    decoration: const InputDecoration(labelText: "Email",labelStyle: TextStyle(color: Colors.black54)),style: const TextStyle(
                    color: Colors.black,
                  ),
                  ),
                  TextField(
                    controller: controller.txtPassword,
                    decoration: const InputDecoration(labelText: "Password",labelStyle: TextStyle(color: Colors.black54)),style: const TextStyle(
                    color: Colors.black,
                  ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 25),
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/signUp');
                    },
                    child: const Center(
                      child: Text(
                        "Don't have an account? Sign Up        ",
                        style: TextStyle(color: Colors.black, fontSize: 13, letterSpacing: 0.8,fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white)),
                    onPressed: () async {
                      String response = await AuthService.authService.signInWithEmailAndPassword(
                        controller.txtEmail.text,
                        controller.txtPassword.text,
                      );

                      User? user = AuthService.authService.getCurrentUser();
                      if (user != null && response == "Success") {
                        Get.offAndToNamed('/home');
                      } else {
                        Get.snackbar('Sign In Failed!', response);
                      }
                    },
                    child: const Text('Sign In',style: TextStyle(color: Colors.black),),
                  ),
                  const SizedBox(height: 10),
                  SignInButton(
                    Buttons.google,
                    onPressed: () async {
                      await GoogleAuthService.googleAuthService.signInWithGoogle();
                      User? user = AuthService.authService.getCurrentUser();
                      if (user != null) {
                        Get.offAndToNamed('/home');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

