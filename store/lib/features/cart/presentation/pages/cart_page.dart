// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:store/features/cart/presentation/bloc/cart_event.dart';
import 'package:store/features/cart/presentation/bloc/cart_state.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _discountController = TextEditingController();

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  void _placeOrder(BuildContext context, {required bool isStripe}) {
    context.read<CartBloc>().add(PlaceOrderRequested(isStripe ? 'Stripe' : 'PayPal'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {
        if (state.status == CartStatus.success) {
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
        } else if (state.status == CartStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("❌ Failed: ${state.errorMessage}"), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final cartItems = state.items;
        final isLoading = state.status == CartStatus.loading;

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
          body: cartItems.isEmpty && state.status != CartStatus.loading
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
                      if (isLoading) const LinearProgressIndicator(),
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
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _discountController,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Coupon Code',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: isLoading ? null : () {
                                    context.read<CartBloc>().add(ApplyDiscountCode(_discountController.text.trim()));
                                  },
                                  child: const Text('Apply'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (state.discountAmount > 0) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Subtotal:'),
                                  Text('\$${state.totalAmount.toStringAsFixed(2)}'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Discount:', style: TextStyle(color: Colors.red)),
                                  Text('-\$${state.discountAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.red)),
                                ],
                              ),
                              const Divider(),
                            ],
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
                                  '\$${state.finalAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 56, 124, 110),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: isLoading ? null : () => _placeOrder(context, isStripe: true),
                                    icon: const Icon(Icons.credit_card),
                                    label: const Text("Stripe"),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: isLoading ? null : () => _placeOrder(context, isStripe: false),
                                    icon: const Icon(Icons.payment),
                                    label: const Text("PayPal"),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                                  ),
                                ),
                              ],
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
