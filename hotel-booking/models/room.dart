abstract class Room {
  final String roomId;
  final int capacity;

  final double pricePerNight;

  const Room({required this.roomId, required this.capacity, required this.pricePerNight});

  String get typeName;
}

class StandardRoom extends Room {
  final bool hasBalcony;

  const StandardRoom({
    required super.roomId,
    required super.capacity,
    required super.pricePerNight,
    this.hasBalcony = false,
  });

  @override
  String get typeName => 'Standard';
}

class SuiteRoom extends Room {
  final bool hasJacuzzi;

  const SuiteRoom({
    required super.roomId,
    required super.capacity,
    required super.pricePerNight,
    this.hasJacuzzi = true,
  });

  @override
  String get typeName => 'Suite';
}