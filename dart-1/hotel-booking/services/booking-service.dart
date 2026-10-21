import 'dart:math';

import '../models/booking.dart';
import '../models/hotel.dart';
import '../models/payment.dart';
import '../models/room.dart';

class BookingService {
  final Hotel hotel;
  final List<Booking> _bookings = [];

  BookingService(this.hotel);

  List<Booking> get bookings => List.unmodifiable(_bookings);

  bool isRoomAvailable(String roomId, DateTime startDate, DateTime endDate) {
    if (startDate.isAfter(endDate) || startDate.isAtSameMomentAs(endDate)) {
      throw ArgumentError('Incorrect date value');
    }

    return !_bookings.any((b) =>
        b.roomId == roomId &&
        b.payment.status == PaymentStatus.success &&
        b.overlaps(startDate, endDate));
  }

  List<Room> getAvailableRooms(DateTime startDate, DateTime endDate, {int guestsCount = 1}) {
    return hotel.rooms.where((room) {
      final isCapacitous = room.capacity >= guestsCount;
      final isFree = isRoomAvailable(room.roomId, startDate, endDate);
      return isCapacitous && isFree;
    }).toList();
  }

  Booking? createBooking({
    required String guestId,
    required String roomId,
    required DateTime startDate,
    required DateTime endDate,
    required PaymentType paymentType,
  }) {
    final room = hotel.rooms.firstWhere(
      (r) => r.roomId == roomId,
      orElse: () => throw Exception('Room is not found'),
    );

    if (!isRoomAvailable(roomId, startDate, endDate)) {
      print('Fail: Room $roomId is booked for these period');
      return null;
    }

    final nights = endDate.difference(startDate).inDays;
    final total = nights * room.pricePerNight;

    final payment = Payment(
      paymentId: 'PAY_${Random().nextInt(10000)}',
      amount: total,
      type: paymentType,
      status: PaymentStatus.success,
    );

    final booking = Booking(
      bookingId: 'BOOK_${Random().nextInt(10000)}',
      roomId: roomId,
      guestId: guestId,
      startDate: startDate,
      endDate: endDate,
      totalPrice: total,
      payment: payment,
    );

    _bookings.add(booking);
    print('Success! ID: ${booking.bookingId}, to pay: $total\$');
    return booking;
  }

  double getTotalRevenue() {
    return _bookings
        .where((b) => b.payment.status == PaymentStatus.success)
        .fold(0.0, (sum, b) => sum + b.totalPrice);
  }

  double getOccupancyRate(DateTime start, DateTime end) {
    if (hotel.rooms.isEmpty) return 0.0;
    
    final totalDaysInPeriod = end.difference(start).inDays;
    if (totalDaysInPeriod <= 0) return 0.0;

    final totalPossibleRoomDays = hotel.rooms.length * totalDaysInPeriod;
    int bookedRoomDays = 0;

    for (final b in _bookings) {
      if (b.payment.status != PaymentStatus.success) continue;

      final overlapStart = b.startDate.isAfter(start) ? b.startDate : start;
      final overlapEnd = b.endDate.isBefore(end) ? b.endDate : end;

      if (overlapStart.isBefore(overlapEnd)) {
        bookedRoomDays += overlapEnd.difference(overlapStart).inDays;
      }
    }

    return (bookedRoomDays / totalPossibleRoomDays) * 100;
  }
}