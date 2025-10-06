import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../models/slot.dart';

// Slot state
class SlotState {
  final Map<String, List<Slot>> groupedSlots;
  final bool isLoading;
  final String? error;
  final Slot? selectedSlot;
  
  const SlotState({
    this.groupedSlots = const {},
    this.isLoading = false,
    this.error,
    this.selectedSlot,
  });
  
  SlotState copyWith({
    Map<String, List<Slot>>? groupedSlots,
    bool? isLoading,
    String? error,
    Slot? selectedSlot,
  }) {
    return SlotState(
      groupedSlots: groupedSlots ?? this.groupedSlots,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedSlot: selectedSlot ?? this.selectedSlot,
    );
  }

  List<String> get availableDates => groupedSlots.keys.toList()..sort();
  
  int get totalAvailableSlots {
    return groupedSlots.values.fold(0, (sum, slots) => sum + slots.length);
  }
}

// Slot provider
class SlotNotifier extends StateNotifier<SlotState> {
  final ApiService _apiService;
  
  SlotNotifier(this._apiService) : super(const SlotState());
  
  Future<void> loadSlots({String? date}) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final groupedSlots = await _apiService.getSlots(date: date);
      
      // Clear selected slot if it's no longer available
      Slot? currentSelection = state.selectedSlot;
      if (currentSelection != null) {
        bool slotStillAvailable = false;
        for (final slots in groupedSlots.values) {
          if (slots.any((slot) => slot.id == currentSelection!.id)) {
            slotStillAvailable = true;
            break;
          }
        }
        if (!slotStillAvailable) {
          currentSelection = null;
        }
      }
      
      state = state.copyWith(
        groupedSlots: groupedSlots,
        isLoading: false,
        selectedSlot: currentSelection,
      );
    } catch (e) {
      print('Error loading slots: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void selectSlot(Slot slot) {
    state = state.copyWith(selectedSlot: slot);
  }

  void clearSelection() {
    state = state.copyWith(selectedSlot: null);
  }
}

final slotProvider = StateNotifierProvider<SlotNotifier, SlotState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return SlotNotifier(apiService);
});