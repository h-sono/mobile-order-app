import 'package:flutter/material.dart';

class MenuDetailScreen extends StatelessWidget {
  final String menuId;
  
  const MenuDetailScreen({super.key, required this.menuId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Detail'),
      ),
      body: Center(
        child: Text('Menu Detail Screen - ID: $menuId'),
      ),
    );
  }
}