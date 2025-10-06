class Slot {
  final int id;
  final String date;
  final String startTime;
  final String endTime;
  final String timeSlot;
  final int maxCapacity;
  final int currentBookings;
  final int remainingCapacity;
  final bool isAvailable;

  Slot({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.timeSlot,
    required this.maxCapacity,
    required this.currentBookings,
    required this.remainingCapacity,
    required this.isAvailable,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      id: json['id'] as int,
      date: json['date'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      timeSlot: json['time_slot'] as String,
      maxCapacity: json['max_capacity'] as int,
      currentBookings: json['current_bookings'] as int,
      remainingCapacity: json['remaining_capacity'] as int,
      isAvailable: json['is_available'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'time_slot': timeSlot,
      'max_capacity': maxCapacity,
      'current_bookings': currentBookings,
      'remaining_capacity': remainingCapacity,
      'is_available': isAvailable,
    };
  }

  bool get isAlmostFull => remainingCapacity <= 2;
}