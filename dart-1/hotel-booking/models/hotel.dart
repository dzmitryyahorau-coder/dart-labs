import 'room.dart';

class Hotel {
  final String hotelId;
  final String name;
  final String address;

  final List<Room> rooms;

  Hotel({
    required this.hotelId,
    required this.name,
    required this.address,
    List<Room>? rooms,
  }) : rooms = rooms ?? [];

}