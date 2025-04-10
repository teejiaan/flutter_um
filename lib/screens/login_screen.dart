import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void handleLogin() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Simulate login logic
    if (email == 'test@example.com' && password == 'password123') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login successful!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome Back!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Email Field
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(24),
                  ), // <- Roundness here
                ),
                prefixIcon: const Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Password Field
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(24),
                  ), // <- Roundness here
                ),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),

            // Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: handleLogin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('Login'),
              ),
            ),

            const SizedBox(height: 12),

            // Optional: Forgot password
            TextButton(
              onPressed: () {
                // Future logic
              },
              child: const Text('Forgot Password?'),
            ),
          ],
        ),
      ),
    );
  }
}
