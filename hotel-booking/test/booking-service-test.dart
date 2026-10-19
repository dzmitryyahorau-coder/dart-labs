import 'package:test/test.dart';
import '../models/payment.dart';
import '../services/booking-service.dart';
import '../mocks/hotel-mocks.dart';
import '../models/hotel.dart';

void main() {
  group('BookingSystem Tests', () {
    late Hotel hotel;
    late BookingService system;

    // Выполняется перед каждым тестом
    setUp(() {
      hotel = HotelMocks.createMockHotel();
      system = BookingService(hotel);
    });

    test('Успешное создание бронирования и расчет стоимости', () {
      final startDate = DateTime(2026, 10, 1);
      final endDate = DateTime(2026, 10, 4); // 3 ночи

      final booking = system.createBooking(
        guestId: HotelMocks.guestAlex.guestId,
        roomId: HotelMocks.standardRoom101.roomId,
        startDate: startDate,
        endDate: endDate,
        paymentType: PaymentType.creditCard,
      );

      expect(booking, isNotNull);
      expect(booking!.nights, equals(3));
      // 3 ночи * 100.0$ = 300.0$
      expect(booking.totalPrice, equals(300.0));
      expect(booking.payment.status, equals(PaymentStatus.success));
    });

    test('Запрет бронирования на пересекающиеся даты (Overlapping)', () {
      final start1 = DateTime(2026, 10, 10);
      final end1 = DateTime(2026, 10, 15);

      // 1. Создаем первое успешное бронирование
      system.createBooking(
        guestId: HotelMocks.guestAlex.guestId,
        roomId: HotelMocks.standardRoom101.roomId,
        startDate: start1,
        endDate: end1,
        paymentType: PaymentType.creditCard,
      );

      // 2. Попытка забронировать ту же комнату на даты внутри первого интервала (12-14 октября)
      final overlapBooking = system.createBooking(
        guestId: HotelMocks.guestElena.guestId,
        roomId: HotelMocks.standardRoom101.roomId,
        startDate: DateTime(2026, 10, 12),
        endDate: DateTime(2026, 10, 14),
        paymentType: PaymentType.cash,
      );

      expect(overlapBooking, isNull); // Должен вернуть null
    });

    test('Допустимость смежных дат (выезд первого гостя = заезд второго)', () {
      final start1 = DateTime(2026, 10, 1);
      final end1 = DateTime(2026, 10, 5);
      final start2 = DateTime(2026, 10, 5); // В этот же день
      final end2 = DateTime(2026, 10, 10);

      system.createBooking(
        guestId: HotelMocks.guestAlex.guestId,
        roomId: HotelMocks.standardRoom101.roomId,
        startDate: start1,
        endDate: end1,
        paymentType: PaymentType.creditCard,
      );

      final secondBooking = system.createBooking(
        guestId: HotelMocks.guestElena.guestId,
        roomId: HotelMocks.standardRoom101.roomId,
        startDate: start2,
        endDate: end2,
        paymentType: PaymentType.creditCard,
      );

      expect(secondBooking, isNotNull); // Смежные даты не пересекаются
    });

    test('Расчет общей выручки отеля (Total Revenue)', () {
      // Бронь 1: 2 ночи * 100$ = 200$
      system.createBooking(
        guestId: HotelMocks.guestAlex.guestId,
        roomId: HotelMocks.standardRoom101.roomId,
        startDate: DateTime(2026, 10, 1),
        endDate: DateTime(2026, 10, 3),
        paymentType: PaymentType.creditCard,
      );

      // Бронь 2: 2 ночи * 250$ = 500$
      system.createBooking(
        guestId: HotelMocks.guestElena.guestId,
        roomId: HotelMocks.suiteRoom201.roomId,
        startDate: DateTime(2026, 10, 1),
        endDate: DateTime(2026, 10, 3),
        paymentType: PaymentType.creditCard,
      );

      expect(system.getTotalRevenue(), equals(700.0));
    });
  });
}