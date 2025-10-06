import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';

class MenuDetailScreen extends StatelessWidget {
  final String menuId;
  
  const MenuDetailScreen({super.key, required this.menuId});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Menu Detail',
      child: Center(
        child: Text('Menu Detail Screen - ID: $menuId'),
      ),
    );
  }
}