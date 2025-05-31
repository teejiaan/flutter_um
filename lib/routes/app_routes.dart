import 'package:flutter/material.dart';
import 'package:flutter_um/screens/main_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/manager_screen.dart';
import '../screens/account_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/main': (context) => const MainScreen(),
  '/manager': (context) => const ManagerScreen(),
  '/admin':
      (context) => const AccountScreen(), // Placeholder for developer screen
};
