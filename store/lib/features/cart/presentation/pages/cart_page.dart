// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:store/features/cart/presentation/bloc/cart_event.dart';
import 'package:store/features/cart/presentation/bloc/cart_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/core/network/payment_service.dart';
import 'package:store/core/injection/injection_container.dart' as di;

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoading = false;

  Future<void> placeOrder(BuildContext context, CartState state) async {
    if (state.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("🛒 Your cart is empty")));
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ You must be logged in to place an order"),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Integration with Payment Service
      final paymentService = PaymentService(); // Or get from DI
      final paymentSuccess = await paymentService.processStripePayment(state.totalAmount);

      if (!paymentSuccess) {
        throw Exception("Payment failed");
      }

      final orderRef = FirebaseFirestore.instance.collection('orders').doc();
      final items = state.items
          .map(
            (item) => {
              'id': item.product.id,
              'title': item.product.title,
              'price': item.product.price,
              'quantity': item.quantity,
            },
          )
          .toList();

      await orderRef.set({
        'orderId': orderRef.id,
        'userId': user.uid,
        'items': items,
        'totalPrice': state.totalAmount,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      context.read<CartBloc>().add(ClearCart());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Order placed successfully!")),
      );

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("✅ Order Placed"),
          content: const Text("Your order has been placed successfully!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Failed to place order: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final cartItems = state.items;

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                const Text("Your Cart"),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 12,
                  child: Text(
                    cartItems.length.toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.teal),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color.fromARGB(255, 230, 230, 230),
          ),
          body: cartItems.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 60,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Your cart is empty',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            final product = item.product;

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: product.image,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) => const Icon(
                                      Icons.broken_image,
                                      size: 40,
                                    ),
                                  ),
                                ),
                                title: Text(product.title),
                                subtitle: Text('\$${product.price}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                      ),
                                      onPressed: () {
                                        if (item.quantity == 1) {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text(
                                                "Remove Product",
                                              ),
                                              content: const Text(
                                                "Remove this product from the cart?",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(ctx).pop(),
                                                  child: const Text("Cancel"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    context
                                                        .read<CartBloc>()
                                                        .add(
                                                          RemoveFromCart(
                                                            product.id,
                                                          ),
                                                        );
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: const Text("Remove"),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          context.read<CartBloc>().add(
                                            UpdateQuantity(
                                              product.id,
                                              item.quantity - 1,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    Text(
                                      item.quantity.toString(),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                      ),
                                      onPressed: () =>
                                          context.read<CartBloc>().add(
                                            UpdateQuantity(
                                              product.id,
                                              item.quantity + 1,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '\$${state.totalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 56, 124, 110),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: isLoading
                                  ? null
                                  : () => placeOrder(context, state),
                              icon: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.check_circle_outline),
                              label: Text(
                                isLoading ? "Placing Order..." : "Place Order",
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
