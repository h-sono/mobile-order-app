import 'package:flutter/material.dart';

class OrderCompleteScreen extends StatelessWidget {
  const OrderCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Complete'),
      ),
      body: const Center(
        child: Text('Order Complete Screen'),
      ),
    );
  }
}