import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller.txtEmail,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: controller.txtPassword,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () {
                  Get.toNamed('/signUp');
                },
                child: const Text("Don't have account? Sign Up")),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  // User null
                  String response = await AuthService.authService.signInWithEmailAndPassword(
                      controller.txtEmail.text, controller.txtPassword.text);

                  // user
                  User? user = AuthService.authService.getCurrentUser();
                  if(user != null && response=="Success")
                  {
                    Get.offAndToNamed('/home');
                  }
                  else
                    {
                      Get.snackbar('Sign In Failed !', response);
                    }
                },
                child: const Text('Sign In'))
          ],
        ),
      ),
    );
  }
}
