import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentService {
  static Future<void> init() async {
    Stripe.publishableKey = "your_stripe_publishable_key";
    await Stripe.instance.applySettings();
  }

  Future<bool> processStripePayment(double amount) async {
    try {
      print("Processing Stripe payment for \$${amount.toStringAsFixed(2)}");
      return true;
    } catch (e) {
      print("Stripe Payment Error: $e");
      return false;
    }
  }

  Future<bool> processPayPalPayment(double amount) async {
    try {
      print("Processing PayPal payment for \$${amount.toStringAsFixed(2)}");
      return true;
    } catch (e) {
      print("PayPal Payment Error: $e");
      return false;
    }
  }
}
