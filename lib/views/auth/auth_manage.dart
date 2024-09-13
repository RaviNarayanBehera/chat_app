import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/views/auth/components/sign_in.dart';
import 'package:chat_app/views/home/home_page.dart';
import 'package:flutter/material.dart';

class AuthManage extends StatelessWidget {
  const AuthManage({super.key});

  @override
  Widget build(BuildContext context) {
    return (AuthService.authService.getCurrentUser() == null
        ? const SignIn()
        : const HomePage());
  }
}
