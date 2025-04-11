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
      await firebaseService.signIn(email, password);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login successful!')));

      Navigator.pushReplacementNamed(context, '/main');
    } catch (e) {
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
                    Navigator.pushNamed(context, '/screen2');
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
