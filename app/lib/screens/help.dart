import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Help & Guide',
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
                          'Welcome to Mobile Order App!',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This guide will help you navigate through the app and place your orders easily.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Step-by-step guide
            Text(
              'How to Place an Order',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Step 1
            _buildStepCard(
              context,
              stepNumber: 1,
              title: 'Browse Menu',
              description: 'Navigate to the menu to see all available items.',
              icon: Icons.restaurant_menu,
              iconColor: Colors.blue,
              details: [
                'Tap on "Menu" from the home screen',
                'Browse through different categories (Pasta, Sides, Drinks)',
                'View item details, prices, and descriptions',
                'Check availability status',
              ],
            ),

            // Step 2
            _buildStepCard(
              context,
              stepNumber: 2,
              title: 'Add Items to Cart',
              description:
                  'Select your favorite items and add them to your cart.',
              icon: Icons.add_shopping_cart,
              iconColor: Colors.green,
              details: [
                'Tap the "Add" button next to any menu item',
                'See confirmation message when item is added',
                'Watch the cart badge update with item count',
                'Tap the cart icon to view your selections',
              ],
            ),

            // Step 3
            _buildStepCard(
              context,
              stepNumber: 3,
              title: 'Review Your Cart',
              description: 'Check your selected items and adjust quantities.',
              icon: Icons.shopping_cart,
              iconColor: Colors.orange,
              details: [
                'View all selected items with prices',
                'Use + and - buttons to adjust quantities',
                'Remove items if needed',
                'See total price calculation',
              ],
            ),

            // Step 4
            _buildStepCard(
              context,
              stepNumber: 4,
              title: 'Select Pickup Time',
              description: 'Choose when you want to pick up your order.',
              icon: Icons.schedule,
              iconColor: Colors.purple,
              details: [
                'Tap "Select Pickup Time" from cart',
                'Choose your preferred date',
                'Select from available time slots',
                'See remaining capacity for each slot',
              ],
            ),

            // Step 5
            _buildStepCard(
              context,
              stepNumber: 5,
              title: 'Confirm Order',
              description: 'Review everything and place your order.',
              icon: Icons.check_circle,
              iconColor: Colors.teal,
              details: [
                'Review your order summary',
                'Confirm pickup time and total amount',
                'Tap "Place Order" to submit',
                'Receive order confirmation with QR code',
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
                          'Helpful Tips',
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
                      'Order during off-peak hours for faster preparation',
                    ),
                    _buildTip(
                      '🕒',
                      'Arrive on time for your selected pickup slot',
                    ),
                    _buildTip('📱', 'Keep your order QR code ready for pickup'),
                    _buildTip(
                      '🔄',
                      'Use the refresh button if menu items don\'t load',
                    ),
                    _buildTip(
                      '🏠',
                      'Tap the home icon to return to main screen anytime',
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
                          'Need More Help?',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'If you encounter any issues or have questions:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    _buildContactInfo(
                      Icons.store,
                      'Visit us at the restaurant counter',
                    ),
                    _buildContactInfo(
                      Icons.phone,
                      'Call us during business hours',
                    ),
                    _buildContactInfo(
                      Icons.refresh,
                      'Try refreshing the app if something doesn\'t work',
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
    BuildContext context, {
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
