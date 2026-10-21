import '../models/guest.dart';
import '../models/hotel.dart';
import '../models/room.dart';

class HotelMocks {
  // Тестовые комнаты
  static final standardRoom101 = StandardRoom(
    roomId: '101',
    capacity: 2,
    pricePerNight: 100.0,
    hasBalcony: true,
  );

  static final standardRoom102 = StandardRoom(
    roomId: '102',
    capacity: 2,
    pricePerNight: 100.0,
    hasBalcony: false,
  );

  static final suiteRoom201 = SuiteRoom(
    roomId: '201',
    capacity: 4,
    pricePerNight: 250.0,
    hasJacuzzi: true,
  );

  // Тестовый отель
  static Hotel createMockHotel() {
    return Hotel(
      hotelId: 'H_001',
      name: 'Grand Hotel Dart',
      address: 'ул. Программистов, 42',
      rooms: [standardRoom101, standardRoom102, suiteRoom201],
    );
  }

  // Тестовые гости
  static const guestAlex = Guest(
    guestId: 'G_1',
    firstName: 'Алексей',
    lastName: 'Иванов',
    phone: '+79990001122',
  );

  static const guestElena = Guest(
    guestId: 'G_2',
    firstName: 'Елена',
    lastName: 'Смирнова',
    phone: '+79998887766',
  );
}