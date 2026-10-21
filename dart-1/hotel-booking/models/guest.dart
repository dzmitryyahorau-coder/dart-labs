class Guest {
  final String guestId;
  final String firstName;
  final String lastName;
  final String phone;

  const Guest({
    required this.guestId,
    required this.firstName,
    required this.lastName,
    required this.phone
  });

  String get fullName => '$firstName $lastName';
}