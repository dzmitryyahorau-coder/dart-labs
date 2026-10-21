enum PaymentType { creditCard, cash }
enum PaymentStatus { success, failed, inProgress }

class Payment {
  final String paymentId;
  final PaymentType type;
  final PaymentStatus status;
  final double amount;

  final DateTime timestamp;

  Payment({
    required this.paymentId,
    required this.type,
    required this.status,
    required this.amount,
    DateTime? timestamp,
  }): timestamp = timestamp ?? DateTime.now();
}