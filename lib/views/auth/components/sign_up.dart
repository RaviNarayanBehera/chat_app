import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/cloud_firestore_service.dart';
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
        title: const Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
          ),
        ),
        leading: IconButton(onPressed: () {
          Get.back(result: '/signIn');
        }, icon: const Icon(Icons.arrow_back,color: Colors.black,)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff1ffbbb), Color(0xff1ffbbb)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff1ffbbb), Color(0xff61fbf1)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AlertDialog(
              backgroundColor: const Color(0xff98fbf8),
              shadowColor: Colors.black,
              title: const Center(child: Text('Create an Account',style: TextStyle(color: Colors.black),)),
              content: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: controller.txtName,
                        decoration: const InputDecoration(labelText: "Name",labelStyle: TextStyle(color: Colors.black54),),style: const TextStyle(color: Colors.black),
                      ),
                      TextField(
                        controller: controller.txtEmail,
                        decoration: const InputDecoration(labelText: "Email",labelStyle: TextStyle(color: Colors.black54)),style: const TextStyle(color: Colors.black),
                      ),
                      TextField(
                        controller: controller.txtPhone,
                        decoration:
                            const InputDecoration(labelText: "Phone Number",labelStyle: TextStyle(color: Colors.black54)),style: const TextStyle(color: Colors.black),
                      ),
                      TextField(
                        controller: controller.txtPassword,
                        decoration: const InputDecoration(labelText: "Password",labelStyle: TextStyle(color: Colors.black54)),style: const TextStyle(color: Colors.black),
                        obscureText: true,
                      ),
                      TextField(
                        controller: controller.txtConfirmPassword,
                        decoration:
                            const InputDecoration(labelText: "Confirm Password",labelStyle: TextStyle(color: Colors.black54)),style: const TextStyle(color: Colors.black),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text(
                          "Already have an account? Sign In",
                          style: TextStyle(
                              color: Colors.black, fontSize: 14,fontWeight: FontWeight.w400),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white)),
                        onPressed: () async {
                          if (controller.txtPassword.text ==
                              controller.txtConfirmPassword.text) {
                            await AuthService.authService
                                .createAccountWithEmailAndPassword(
                              controller.txtEmail.text,
                              controller.txtPassword.text,
                            );

                            UserModel user = UserModel(
                              name: controller.txtName.text,
                              email: controller.txtEmail.text,
                              phone: controller.txtPhone.text,
                              token: "",
                              image:
                                  "https://img.freepik.com/premium-photo/stylish-man-flat-vector-profile-picture-ai-generated_606187-310.jpg",
                            );

                            await CloudFireStoreService.cloudFireStoreService
                                .insertUserIntoFireStore(user);
                            Get.back();

                            controller.txtEmail.clear();
                            controller.txtPassword.clear();
                            controller.txtName.clear();
                            controller.txtConfirmPassword.clear();
                            controller.txtPhone.clear();
                          }
                        },
                        child: const Text('Sign Up',style: TextStyle(color: Colors.black),),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}
