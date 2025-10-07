import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../providers/menu_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/language_provider.dart';
import '../widgets/app_scaffold.dart';

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
      final currentLocale = ref.read(languageProvider);
      ref.read(menuProvider.notifier).loadMenu(locale: currentLocale.languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final currentLocale = ref.watch(languageProvider);
    final l10n = AppLocalizations.of(context)!;

    // Listen for language changes and reload menu
    ref.listen<Locale>(languageProvider, (previous, next) {
      if (previous != null && previous.languageCode != next.languageCode) {
        ref.read(menuProvider.notifier).reloadForLocale(next.languageCode);
      }
    });

    return AppScaffold(
      title: l10n.menuTitle,
      actions: [
        Consumer(
          builder: (context, ref, child) {
            final cartState = ref.watch(cartProvider);
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    context.go('/cart');
                  },
                ),
                if (cartState.itemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cartState.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            ref.read(menuProvider.notifier).loadMenu(locale: currentLocale.languageCode);
          },
        ),
      ],
      child: _buildBody(menuState),
    );
  }

  Widget _buildBody(MenuState menuState) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(languageProvider);

    if (menuState.isLoading) {
      return Center(
        child: CircularProgressIndicator(semanticsLabel: l10n.loading),
      );
    }

    if (menuState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(l10n.error, style: Theme.of(context).textTheme.headlineSmall),
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
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    if (menuState.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              l10n.noMenuItems,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Display menu items with improved UI - no overflow
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: menuState.items.length,
      itemBuilder: (context, index) {
        final item = menuState.items[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: InkWell(
            onTap: () {
              // Navigate to menu detail screen
              context.go('/menu/${item.id}');
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Image
                  item.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            item.imageUrl!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: const Icon(Icons.restaurant),
                              );
                            },
                          ),
                        )
                      : Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Icon(Icons.restaurant),
                        ),
                  const SizedBox(width: 12),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.getLocalizedName(currentLocale.languageCode),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (item.getLocalizedDescription(
                              currentLocale.languageCode,
                            ) !=
                            null) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.getLocalizedDescription(
                              currentLocale.languageCode,
                            )!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              item.getLocalizedCategory(currentLocale.languageCode),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            if (item.localeFallback) ...[
                              const SizedBox(width: 4),
                              Icon(
                                Icons.translate,
                                size: 12,
                                color: Colors.orange[600],
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Price and Add button
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '¥${item.price.toInt()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 70,
                        height: 32,
                        child: ElevatedButton(
                          onPressed: () {
                            ref.read(cartProvider.notifier).addItem(item);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${item.getLocalizedName(currentLocale.languageCode)} added to cart',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                          child: Text(
                            l10n.addToCart.length > 6 ? 'Add' : l10n.addToCart,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
