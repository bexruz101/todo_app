import 'package:flutter/material.dart';
import 'package:todo_app/ui/auth/pages/sign_in_page.dart';
import 'package:todo_app/ui/auth/pages/sign_up_page.dart';

class AuthScreen extends StatefulWidget {
  @override
  createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn == true) {
      return SignInPage(toggleView: toggleView,);
    } else {
      return SignUpPage(toggleView: toggleView,);
    }
  }
}
