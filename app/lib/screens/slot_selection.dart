import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/slot_provider.dart';
import '../models/slot.dart';
import '../widgets/app_scaffold.dart';

class SlotSelectionScreen extends ConsumerStatefulWidget {
  const SlotSelectionScreen({super.key});

  @override
  ConsumerState<SlotSelectionScreen> createState() =>
      _SlotSelectionScreenState();
}

class _SlotSelectionScreenState extends ConsumerState<SlotSelectionScreen> {
  String? selectedDate;

  @override
  void initState() {
    super.initState();
    // Load slots when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(slotProvider.notifier).loadSlots();
    });
  }

  @override
  Widget build(BuildContext context) {
    final slotState = ref.watch(slotProvider);

    return AppScaffold(
      title: 'Select Pickup Time',
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            ref.read(slotProvider.notifier).loadSlots(date: selectedDate);
          },
        ),
      ],
      bottomNavigationBar: slotState.selectedSlot != null
          ? Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.schedule, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selected Time',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '${slotState.selectedSlot!.date} ${slotState.selectedSlot!.timeSlot}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${slotState.selectedSlot!.remainingCapacity} spots left',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to order confirmation
                        context.go('/order-confirmation');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Confirm Time Slot',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
      child: _buildBody(slotState),
    );
  }

  Widget _buildBody(SlotState slotState) {
    if (slotState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (slotState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Error loading time slots',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              slotState.error!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(slotProvider.notifier).loadSlots(date: selectedDate);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (slotState.groupedSlots.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.schedule_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No time slots available',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Please try again later',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Date filter chips
        if (slotState.availableDates.isNotEmpty)
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: slotState.availableDates.length,
              itemBuilder: (context, index) {
                final date = slotState.availableDates[index];
                final isSelected = selectedDate == date;

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(_formatDate(date)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedDate = selected ? date : null;
                      });
                      ref
                          .read(slotProvider.notifier)
                          .loadSlots(date: selected ? date : null);
                    },
                  ),
                );
              },
            ),
          ),

        // Slots list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: slotState.groupedSlots.length,
            itemBuilder: (context, index) {
              final date = slotState.availableDates[index];
              final slots = slotState.groupedSlots[date]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      _formatDate(date),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: slots.length,
                    itemBuilder: (context, slotIndex) {
                      final slot = slots[slotIndex];
                      final isSelected = slotState.selectedSlot?.id == slot.id;

                      return _buildSlotCard(slot, isSelected);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSlotCard(Slot slot, bool isSelected) {
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? Colors.blue[50] : null,
      child: InkWell(
        onTap: () {
          ref.read(slotProvider.notifier).selectSlot(slot);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: isSelected
                ? Border.all(color: Colors.blue, width: 2)
                : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                slot.timeSlot,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isSelected ? Colors.blue : null,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people,
                    size: 16,
                    color: slot.isAlmostFull ? Colors.orange : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${slot.remainingCapacity} left',
                    style: TextStyle(
                      fontSize: 12,
                      color: slot.isAlmostFull
                          ? Colors.orange
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day + 1) {
      return 'Tomorrow';
    } else {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}';
    }
  }
}
