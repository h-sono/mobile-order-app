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
    try {
      return Slot(
        id: _parseInt(json['id']),
        date: _parseString(json['date']),
        startTime: _parseString(json['start_time']),
        endTime: _parseString(json['end_time']),
        timeSlot: _parseString(json['time_slot']),
        maxCapacity: _parseInt(json['max_capacity']),
        currentBookings: _parseInt(json['current_bookings']),
        remainingCapacity: _parseInt(json['remaining_capacity']),
        isAvailable: _parseBool(json['is_available']),
      );
    } catch (e) {
      throw Exception('Failed to parse Slot from JSON: $e. JSON: $json');
    }
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    if (value is double) return value.toInt();
    throw Exception('Cannot parse int from $value (${value.runtimeType})');
  }

  static String _parseString(dynamic value) {
    if (value is String) return value;
    if (value != null) return value.toString();
    throw Exception('Cannot parse string from null value');
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      final lower = value.toLowerCase();
      if (lower == 'true' || lower == '1') return true;
      if (lower == 'false' || lower == '0') return false;
    }
    throw Exception('Cannot parse bool from $value (${value.runtimeType})');
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