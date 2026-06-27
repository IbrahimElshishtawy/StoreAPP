import 'package:flutter/material.dart';
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
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => context.read<CartBloc>().add(ClearCart()),
          ),
        ],
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state.status == CartStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order placed successfully!'), backgroundColor: Colors.green),
            );
          } else if (state.status == CartStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'An error occurred'), backgroundColor: Colors.red),
            );
          }
          if (state.discountCode != null && state.discountCode != _codeController.text) {
            _codeController.text = state.discountCode!;
          }
        },
        builder: (context, state) {
          if (state.status == CartStatus.loading) {
            return const LoadingIndicator();
          }

          if (state.items.isEmpty) {
            return const EmptyState(
              message: 'Your cart is empty',
              icon: Icons.shopping_cart_outlined,
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: Image.network(item.product.image, width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(item.product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text('\$${item.product.price} x ${item.quantity}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                if (item.quantity > 1) {
                                  context.read<CartBloc>().add(UpdateQuantity(item.product.id, item.quantity - 1));
                                } else {
                                  context.read<CartBloc>().add(RemoveFromCart(item.product.id));
                                }
                              },
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => context.read<CartBloc>().add(UpdateQuantity(item.product.id, item.quantity + 1)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildSummary(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummary(BuildContext context, CartState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _codeController,
                  decoration: const InputDecoration(hintText: 'Discount Code', border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => context.read<CartBloc>().add(ApplyDiscountCode(_codeController.text.trim())),
                child: const Text('Apply'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal', style: TextStyle(fontSize: 16)),
              Text('\$${state.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
            ],
          ),
          if (state.discountAmount > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Discount', style: TextStyle(fontSize: 16, color: Colors.green)),
                Text('-\$${state.discountAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, color: Colors.green)),
              ],
            ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('\$${state.finalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
                  onPressed: () => context.read<CartBloc>().add(PlaceOrderRequested('Stripe')),
                  child: const Text('Pay with Stripe'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 16)),
                  onPressed: () => context.read<CartBloc>().add(PlaceOrderRequested('PayPal')),
                  child: const Text('Pay with PayPal'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
