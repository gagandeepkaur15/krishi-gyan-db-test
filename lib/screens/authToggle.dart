import 'package:flutter/material.dart';
import 'package:krishi_test/screens/profile.dart';
import 'package:krishi_test/screens/signin.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthToggle extends StatelessWidget {
  const AuthToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      return SignIn();
    } else {
      return Profile();
    }
  }
}