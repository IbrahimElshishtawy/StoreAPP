import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:store/features/cart/presentation/bloc/cart_state.dart';
import 'package:store/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:store/features/payment/presentation/bloc/payment_event.dart';
import 'package:store/features/payment/presentation/bloc/payment_state.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Order Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text('Total items: ${cartState.items.length}'),
                Text('Total amount: \$${cartState.discountedTotal.toStringAsFixed(2)}'),
                const Divider(height: 32),
                const Text('Select Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                BlocConsumer<PaymentBloc, PaymentState>(
                  listener: (context, state) {
                    if (state is PaymentSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment Successful!')));
                      Navigator.popUntil(context, ModalRoute.withName('/home'));
                    } else if (state is PaymentError) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
                    if (state is PaymentLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.credit_card),
                          title: const Text('Stripe (Card)'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            context.read<PaymentBloc>().add(StripePaymentRequested(cartState.discountedTotal));
                          },
                        ),
                        const SizedBox(height: 8),
                        ListTile(
                          leading: const Icon(Icons.paypal),
                          title: const Text('PayPal'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            context.read<PaymentBloc>().add(PayPalPaymentRequested(cartState.discountedTotal));
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
