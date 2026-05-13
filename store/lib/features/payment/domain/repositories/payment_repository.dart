import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';

abstract class PaymentRepository {
  Future<Either<Failure, void>> processStripePayment(double amount);
  Future<Either<Failure, void>> processPayPalPayment(double amount);
}
