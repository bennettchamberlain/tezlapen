class PaymentResponse {
  PaymentResponse({
    required this.isSuccess,
    required this.message,
  });
  final bool isSuccess;
  final String message;
}
