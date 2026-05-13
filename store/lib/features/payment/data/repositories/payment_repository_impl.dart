import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/payment/domain/repositories/payment_repository.dart';
import 'package:store/features/payment/data/datasources/stripe_service.dart';
import 'package:store/features/payment/data/datasources/paypal_service.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final StripeService stripeService;
  final PayPalService payPalService;

  PaymentRepositoryImpl(this.stripeService, this.payPalService);

  @override
  Future<Either<Failure, void>> processStripePayment(double amount) async {
    try {
      await stripeService.initPaymentSheet(amount);
      await stripeService.presentPaymentSheet();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> processPayPalPayment(double amount) async {
    try {
      await payPalService.executePayment(amount);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
