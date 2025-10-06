import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/cart_provider.dart';
import '../providers/slot_provider.dart';
import '../providers/order_provider.dart';

class OrderConfirmationScreen extends ConsumerStatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  ConsumerState<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends ConsumerState<OrderConfirmationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _instructionsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final slotState = ref.watch(slotProvider);
    final orderState = ref.watch(orderProvider);

    if (cartState.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Confirmation')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('Your cart is empty', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      );
    }

    if (slotState.selectedSlot == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Confirmation')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.schedule_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('Please select a pickup time', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
      ),
      body: orderState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Summary
                    _buildOrderSummary(cartState, slotState),
                    const SizedBox(height: 24),
                    
                    // Customer Information
                    _buildCustomerForm(),
                    const SizedBox(height: 24),
                    
                    // Special Instructions
                    _buildSpecialInstructions(),
                    const SizedBox(height: 24),
                    
                    // Error Display
                    if (orderState.error != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          border: Border.all(color: Colors.red[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red[700]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                orderState.error!,
                                style: TextStyle(color: Colors.red[700]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Place Order Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: orderState.isLoading ? null : _placeOrder,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Place Order',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildOrderSummary(CartState cartState, SlotState slotState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Pickup Time
            Row(
              children: [
                const Icon(Icons.schedule, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Pickup Time', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(
                        '${slotState.selectedSlot!.date} ${slotState.selectedSlot!.timeSlot}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Items
            ...cartState.items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text('${item.menuItem.name} x${item.quantity}'),
                  ),
                  Text('\$${item.totalPrice.toStringAsFixed(2)}'),
                ],
              ),
            )),
            
            const Divider(),
            
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total (${cartState.itemCount} items)',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '\$${cartState.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Information',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email (optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number (optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialInstructions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Special Instructions',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _instructionsController,
              decoration: const InputDecoration(
                labelText: 'Any special requests? (optional)',
                border: OutlineInputBorder(),
                hintText: 'e.g., Extra sauce, no onions, etc.',
              ),
              maxLines: 3,
              maxLength: 500,
            ),
          ],
        ),
      ),
    );
  }

  void _placeOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cartState = ref.read(cartProvider);
    final slotState = ref.read(slotProvider);

    await ref.read(orderProvider.notifier).createOrder(
      slotId: slotState.selectedSlot!.id,
      customerName: _nameController.text.trim(),
      customerEmail: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      customerPhone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      items: cartState.items,
      specialInstructions: _instructionsController.text.trim().isEmpty ? null : _instructionsController.text.trim(),
    );

    final orderState = ref.read(orderProvider);
    if (orderState.currentOrder != null) {
      // Clear cart and slot selection
      ref.read(cartProvider.notifier).clearCart();
      ref.read(slotProvider.notifier).clearSelection();
      
      // Navigate to order complete screen
      if (mounted) {
        context.go('/order-complete');
      }
    }
  }
}