import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import 'language_toggle.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showHomeAction;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;

  const AppScaffold({
    super.key,
    required this.title,
    required this.child,
    this.showHomeAction = true,
    this.actions,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    List<Widget> appBarActions = [];
    
    // Add custom actions first
    if (actions != null) {
      appBarActions.addAll(actions!);
    }
    
    // Add language toggle
    appBarActions.add(const LanguageToggle());
    
    // Always add help action
    appBarActions.add(
      IconButton(
        icon: const Icon(Icons.help_outline),
        onPressed: () {
          context.go('/help');
        },
        tooltip: 'Help',
      ),
    );
    
    // Add home action if enabled
    if (showHomeAction) {
      appBarActions.add(
        IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            context.go('/');
          },
          tooltip: l10n.home,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: appBarActions.isNotEmpty ? appBarActions : null,
      ),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}