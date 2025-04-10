import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/login_page.dart';
import '../screens/register_acc_page.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const HomeScreen(),
  '/screen1': (context) => const LoginPage(),
  '/screen2': (context) => const RegisterPage(),
};
