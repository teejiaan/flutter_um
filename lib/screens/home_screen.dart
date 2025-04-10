import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Centered Image
              Image.asset(
                'assets/bank_islam_logo.png',
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 50),

              // Custom Buttons with small graphics
              CustomButton(
                label: 'Login',
                imagePath: 'assets/orange_back.jpeg',
                onPressed: () => Navigator.pushNamed(context, '/screen1'),
              ),
              // const SizedBox(height: 16),
              // CustomButton(
              //   label: 'Go to Screen 2',
              //   imagePath: 'assets/orange_back.jpeg',
              //   onPressed: () => Navigator.pushNamed(context, '/screen2'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
