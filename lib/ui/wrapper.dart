import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/ui/home/home_screen.dart';

import 'auth/auth_screen.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserModel?>();
    if (user == null) {
      return AuthScreen();
    } else {
      return HomeScreen();
    }
  }
}
