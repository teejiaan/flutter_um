import 'package:flutter/material.dart';
import 'package:flutter_um/screens/cart_screen.dart';
import 'package:flutter_um/screens/main_screen.dart';
import 'package:flutter_um/screens/order_history_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/shop_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const HomeScreen(),
  '/screen1': (context) => const LoginScreen(),
  '/screen2': (context) => const RegisterScreen(),
  '/main': (context) => const MainScreen(),
};
