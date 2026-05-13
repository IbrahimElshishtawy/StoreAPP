import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/payment/domain/repositories/payment_repository.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository repository;

  PaymentBloc(this.repository) : super(PaymentInitial()) {
    on<StripePaymentRequested>((event, emit) async {
      emit(PaymentLoading());
      final result = await repository.processStripePayment(event.amount);
      result.fold(
        (failure) => emit(PaymentError(failure.message)),
        (_) => emit(PaymentSuccess()),
      );
    });

    on<PayPalPaymentRequested>((event, emit) async {
      emit(PaymentLoading());
      final result = await repository.processPayPalPayment(event.amount);
      result.fold(
        (failure) => emit(PaymentError(failure.message)),
        (_) => emit(PaymentSuccess()),
      );
    });
  }
}
