import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Order App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Mobile Order App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                context.go('/menu');
              },
              child: const Text('View Menu'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.go('/cart');
              },
              child: const Text('View Cart'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.go('/slot-selection');
              },
              child: const Text('Select Pickup Time'),
            ),
          ],
        ),
      ),
    );
  }
}
