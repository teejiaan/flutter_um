import 'package:flutter/material.dart';
import '../widgets/login_register_template.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final dobController = TextEditingController();

  void handleRegister() {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    // Handle successful registration logic here
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Registered successfully!')));
    Navigator.pop(context); // Optionally go back to login
  }

  @override
  Widget build(BuildContext context) {
    return LoginRegisterTemplate(
      title: 'Create an Account',
      submitLabel: 'Register',
      onSubmit: handleRegister,
      fields: [
        TextField(
          controller: usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 16),
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
        TextField(
          controller: dobController,
          readOnly: true, //Prevent keyboard from showing
          decoration: const InputDecoration(
            labelText: 'Date of Birth',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            prefixIcon: Icon(Icons.cake),
          ),
          onTap: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (selectedDate != null) {
              dobController.text =
                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
            }
          },
        ),
      ],
    );
  }
}
