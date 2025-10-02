import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/menu_provider.dart';

class MenuListScreen extends ConsumerStatefulWidget {
  const MenuListScreen({super.key});

  @override
  ConsumerState<MenuListScreen> createState() => _MenuListScreenState();
}

class _MenuListScreenState extends ConsumerState<MenuListScreen> {
  @override
  void initState() {
    super.initState();
    // Load menu data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(menuProvider.notifier).loadMenu();
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(menuProvider.notifier).loadMenu();
            },
          ),
        ],
      ),
      body: _buildBody(menuState),
    );
  }

  Widget _buildBody(MenuState menuState) {
    if (menuState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (menuState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading menu',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              menuState.error!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(menuProvider.notifier).loadMenu();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (menuState.items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No menu items available',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Menu is empty but connection successful!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    // This will be used when menu items are available
    return ListView.builder(
      itemCount: menuState.items.length,
      itemBuilder: (context, index) {
        final item = menuState.items[index];
        return ListTile(
          title: Text(item['name'] ?? 'Unknown Item'),
          subtitle: Text(item['description'] ?? ''),
          trailing: Text('\$${item['price'] ?? '0.00'}'),
        );
      },
    );
  }
}