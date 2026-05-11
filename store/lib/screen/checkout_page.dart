import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:store/features/cart/presentation/bloc/cart_state.dart';
import 'package:store/core/network/payment_service.dart';
import 'package:store/core/injection/injection_container.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return ListTile(
                        title: Text(item.product.title),
                        subtitle: Text('${item.quantity} x \$${item.product.price}'),
                        trailing: Text('\$${(item.quantity * item.product.price).toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
                const Divider(),
                Text(
                  'Total: \$${state.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final paymentService = sl<PaymentService>();
                    final success = await paymentService.processStripePayment(state.totalAmount);
                    if (context.mounted) {
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Payment Successful!')),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Payment Failed!')),
                        );
                      }
                    }
                  },
                  child: const Text('Pay with Stripe'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final paymentService = sl<PaymentService>();
                    final success = await paymentService.processPayPalPayment(state.totalAmount);
                    if (context.mounted) {
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Payment Successful!')),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Payment Failed!')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Pay with PayPal', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
