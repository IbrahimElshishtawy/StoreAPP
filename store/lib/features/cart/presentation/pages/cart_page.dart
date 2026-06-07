import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:store/features/cart/presentation/bloc/cart_event.dart';
import 'package:store/features/cart/presentation/bloc/cart_state.dart';
import 'package:store/presentation/widgets/common_ui.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _discountController = TextEditingController();

  void _placeOrder(BuildContext context, String method) {
    context.read<CartBloc>().add(PlaceOrderRequested(paymentMethod: method));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {
        if (state.status == CartStatus.success) {
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
            SnackBar(content: Text("❌ ${state.errorMessage}"), backgroundColor: Colors.red),
          );
        }
      },
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
          body: state.status == CartStatus.loading
              ? const LoadingIndicator()
              : cartItems.isEmpty && state.status != CartStatus.success
                  ? const EmptyState(message: 'Your cart is empty')
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
                                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                                        errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 40),
                                      ),
                                    ),
                                    title: Text(product.title),
                                    subtitle: Text('\$${product.price}'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove_circle_outline),
                                          onPressed: () {
                                            if (item.quantity == 1) {
                                              _showRemoveDialog(context, product.id);
                                            } else {
                                              context.read<CartBloc>().add(UpdateQuantity(product.id, item.quantity - 1));
                                            }
                                          },
                                        ),
                                        Text(item.quantity.toString(), style: const TextStyle(fontSize: 16)),
                                        IconButton(
                                          icon: const Icon(Icons.add_circle_outline),
                                          onPressed: () => context.read<CartBloc>().add(UpdateQuantity(product.id, item.quantity + 1)),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          _buildOrderSummary(context, state),
                        ],
                      ),
                    ),
        );
      },
    );
  }

  void _showRemoveDialog(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Remove Product"),
        content: const Text("Remove this product from the cart?"),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              context.read<CartBloc>().add(RemoveFromCart(productId));
              Navigator.of(ctx).pop();
            },
            child: const Text("Remove"),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _discountController,
            decoration: InputDecoration(
              hintText: 'Enter discount code (e.g., SAVE10)',
              suffixIcon: IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  context.read<CartBloc>().add(ApplyDiscountCode(_discountController.text.trim()));
                },
              ),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          if (state.discountAmount > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Discount:', style: TextStyle(color: Colors.red)),
                  Text('-\$${state.discountAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                '\$${state.finalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 56, 124, 110)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _placeOrder(context, 'Stripe'),
                  icon: const Icon(Icons.credit_card),
                  label: const Text("Stripe"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _placeOrder(context, 'PayPal'),
                  icon: const Icon(Icons.payment),
                  label: const Text("PayPal"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
