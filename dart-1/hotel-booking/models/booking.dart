import 'payment.dart';

class Booking {
  final String bookingId;
  final String roomId;
  final String guestId;
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  Payment payment;

  Booking({
    required this.bookingId,
    required this.roomId,
    required this.guestId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.payment,
  });

  int get nights => endDate.difference(startDate).inDays;

  bool overlaps(DateTime start, DateTime end) {
    return startDate.isBefore(end) && endDate.isAfter(start);
  }
}