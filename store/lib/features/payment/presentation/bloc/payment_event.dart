abstract class PaymentEvent {}

class StripePaymentRequested extends PaymentEvent {
  final double amount;
  StripePaymentRequested(this.amount);
}

class PayPalPaymentRequested extends PaymentEvent {
  final double amount;
  PayPalPaymentRequested(this.amount);
}
