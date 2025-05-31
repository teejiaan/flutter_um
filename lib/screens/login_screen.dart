import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/login_register_template.dart';
import '../services/firebase_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final firebaseService = FirebaseService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      // Sign in the user
      await firebaseService.signIn(email, password);

      // Get the current authenticated user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not found after login");
      }

      final userId = user.uid;

      // Fetch the user's Firestore document using UID
      final userDocSnapshot =
          await FirebaseFirestore.instance.collection('user').doc(userId).get();

      if (!userDocSnapshot.exists) {
        throw Exception("No user document found for UID: $userId");
      }

      final userData = userDocSnapshot.data();
      print("DEBUG: Full user document = $userData");

      final role = userData?['role'];
      print("DEBUG: User role is: $role");

      // Show success feedback
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login successful!')));

      // Redirect based on role
      if (role == 'manager') {
        Navigator.pushReplacementNamed(context, '/manager');
      } else if (role == 'admin') {
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        Navigator.pushReplacementNamed(context, '/main');
      }
    } catch (e) {
      print("DEBUG: Login error = $e");
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Login Failed'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginRegisterTemplate(
      title: 'Login to Your Account',
      submitLabel: 'Login',
      onSubmit: handleLogin,
      fields: [
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            prefixIcon: Icon(Icons.email),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            prefixIcon: Icon(Icons.lock),
          ),
        ),
      ],
    );
  }
}
