import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/cloud_firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/auth_service.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller.txtName,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: controller.txtEmail,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: controller.txtPhone,
              decoration: const InputDecoration(labelText: "Phone Number"),
            ),
            TextField(
              controller: controller.txtPassword,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            TextField(
              controller: controller.txtConfirmPassword,
              decoration: const InputDecoration(labelText: "Confirm Password"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Already have account? Sign In")),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (controller.txtPassword.text ==
                      controller.txtConfirmPassword.text) {
                    await AuthService.authService
                        .createAccountWithEmailAndPassword(
                            controller.txtEmail.text,
                            controller.txtPassword.text);

                    UserModel user = UserModel(
                        name: controller.txtName.text,
                        email: controller.txtEmail.text,
                        phone: controller.txtPhone.text,
                        token: "",
                        image: "https://img.freepik.com/premium-photo/stylish-man-flat-vector-profile-picture-ai-generated_606187-310.jpg");

                    CloudFireStoreService.cloudFireStoreService
                        .insertUserIntoFireStore(user);
                    Get.back();

                    controller.txtEmail.clear();
                    controller.txtPassword.clear();
                    controller.txtName.clear();
                    controller.txtConfirmPassword.clear();
                    controller.txtPhone.clear();
                  }
                },
                child: const Text('Sign Up'))
          ],
        ),
      ),
    );
  }
}
