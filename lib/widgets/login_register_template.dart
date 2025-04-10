import 'package:flutter/material.dart';

class LoginRegisterTemplate extends StatelessWidget {
  final String title;
  final List<Widget> fields;
  final VoidCallback onSubmit;
  final String submitLabel;

  const LoginRegisterTemplate({
    super.key,
    required this.title,
    required this.fields,
    required this.onSubmit,
    required this.submitLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ...fields,
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
              child: Text(submitLabel),
            ),
          ],
        ),
      ),
    );
  }
}
