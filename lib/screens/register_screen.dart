import 'package:flutter/material.dart';
import '../widgets/login_register_template.dart';
import '../services/firebase_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final firebaseService = FirebaseService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void handleRegister() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    try {
      await firebaseService.register(email, password);

      // Registration successful
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registration successful!')));

      Navigator.pushReplacementNamed(context, '/screen1'); // Go back to login
    } catch (e) {
      // Show error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginRegisterTemplate(
      title: 'Create an Account',
      submitLabel: 'Register',
      onSubmit: handleRegister,
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
        const SizedBox(height: 16),
        TextField(
          controller: confirmPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Confirm Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            prefixIcon: Icon(Icons.lock_outline),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'By creating an account, you agree to our Terms of Service and Privacy Policy.',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
