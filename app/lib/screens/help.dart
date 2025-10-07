import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../widgets/app_scaffold.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return AppScaffold(
      title: l10n.helpGuide,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.waving_hand, color: Colors.orange[600]),
                        const SizedBox(width: 8),
                        Text(
                          l10n.welcomeToApp,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.helpDescription,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Step-by-step guide
            Text(
              l10n.howToPlaceOrder,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Step 1
            _buildStepCard(
              context,
              l10n,
              stepNumber: 1,
              title: l10n.browseMenu,
              description: l10n.browseMenuDesc,
              icon: Icons.restaurant_menu,
              iconColor: Colors.blue,
              details: [
                l10n.tapMenuFromHome,
                l10n.browseDifferentCategories,
                l10n.viewItemDetails,
                l10n.checkAvailability,
              ],
            ),

            // Step 2
            _buildStepCard(
              context,
              l10n,
              stepNumber: 2,
              title: l10n.addItemsToCart,
              description: l10n.addItemsToCartDesc,
              icon: Icons.add_shopping_cart,
              iconColor: Colors.green,
              details: [
                l10n.tapAddButton,
                l10n.seeConfirmationMessage,
                l10n.watchCartBadge,
                l10n.tapCartIcon,
              ],
            ),

            // Step 3
            _buildStepCard(
              context,
              l10n,
              stepNumber: 3,
              title: l10n.reviewYourCart,
              description: l10n.reviewYourCartDesc,
              icon: Icons.shopping_cart,
              iconColor: Colors.orange,
              details: [
                l10n.viewSelectedItems,
                l10n.useAddRemoveButtons,
                l10n.removeItemsIfNeeded,
                l10n.seeTotalCalculation,
              ],
            ),

            // Step 4
            _buildStepCard(
              context,
              l10n,
              stepNumber: 4,
              title: l10n.selectPickupTime,
              description: l10n.selectPickupTimeDesc,
              icon: Icons.schedule,
              iconColor: Colors.purple,
              details: [
                l10n.tapSelectPickupTime,
                l10n.choosePreferredDate,
                l10n.selectFromTimeSlots,
                l10n.seeRemainingCapacity,
              ],
            ),

            // Step 5
            _buildStepCard(
              context,
              l10n,
              stepNumber: 5,
              title: l10n.confirmOrder,
              description: l10n.confirmOrderDesc,
              icon: Icons.check_circle,
              iconColor: Colors.teal,
              details: [
                l10n.reviewOrderSummary,
                l10n.confirmPickupAndTotal,
                l10n.tapPlaceOrder,
                l10n.receiveOrderConfirmation,
              ],
            ),

            const SizedBox(height: 24),

            // Tips section
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          l10n.helpfulTips,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTip(
                      '💡',
                      l10n.orderOffPeakHours,
                    ),
                    _buildTip(
                      '🕒',
                      l10n.arriveOnTime,
                    ),
                    _buildTip('📱', l10n.keepQrCodeReady),
                    _buildTip(
                      '🔄',
                      l10n.useRefreshButton,
                    ),
                    _buildTip(
                      '🏠',
                      l10n.tapHomeIcon,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Contact section
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.support_agent, color: Colors.green[700]),
                        const SizedBox(width: 8),
                        Text(
                          l10n.needMoreHelp,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.needMoreHelpDesc,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    _buildContactInfo(
                      Icons.store,
                      l10n.visitRestaurantCounter,
                    ),
                    _buildContactInfo(
                      Icons.phone,
                      l10n.callDuringBusinessHours,
                    ),
                    _buildContactInfo(
                      Icons.refresh,
                      l10n.tryRefreshingApp,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(
    BuildContext context,
    AppLocalizations l10n, {
    required int stepNumber,
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required List<String> details,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: iconColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      '$stepNumber',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(icon, color: iconColor, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...details.map(
              (detail) => Padding(
                padding: const EdgeInsets.only(left: 56, bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(
                        color: iconColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(child: Text(detail)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(String emoji, String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(child: Text(tip, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String info) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green[700]),
          const SizedBox(width: 8),
          Expanded(child: Text(info, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
