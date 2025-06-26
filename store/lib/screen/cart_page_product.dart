// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:store/models/prodect_model.dart';
import 'package:store/widget/items_cart_product.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateTotal();
  }

  void _calculateTotal() {
    _totalPrice = 0.0;
    for (var product in cartItems) {
      final qty = cartQuantities[product.id] ?? 1;
      _totalPrice += ((product.price ?? 0) * qty);
    }
  }

  void _incrementQuantity(String productId) {
    setState(() {
      cartQuantities[productId] = (cartQuantities[productId] ?? 1) + 1;
      _calculateTotal();
    });
  }

  void _decrementQuantity(String productId) {
    setState(() {
      if (cartQuantities[productId] != null) {
        cartQuantities[productId] = cartQuantities[productId]! - 1;
        if (cartQuantities[productId]! <= 0) {
          cartQuantities.remove(productId);
          cartItems.removeWhere((item) => item.id == productId);
        }
        _calculateTotal();
      }
    });
  }

  void _placeOrder() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Order Placed"),
        content: const Text("Your order has been placed successfully!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );

    setState(() {
      cartItems.clear();
      cartQuantities.clear();
      _totalPrice = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cartItems.isEmpty
          ? const Center(child: Text('The cart is empty'))
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final product = cartItems[index];
                        final quantity = cartQuantities[product.id] ?? 1;

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
                                imageUrl: product.imageUrl ?? '',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                placeholder: (_, __) =>
                                    const CircularProgressIndicator(
                                      strokeWidth: 1,
                                    ),
                                errorWidget: (_, __, ___) =>
                                    const Icon(Icons.broken_image, size: 40),
                              ),
                            ),
                            title: Text(product.title ?? ''),
                            subtitle: Text('\$${product.price}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () =>
                                      _decrementQuantity(product.id),
                                ),
                                Text(
                                  quantity.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () =>
                                      _incrementQuantity(product.id),
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
                              '\$${_totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (cartItems.isNotEmpty)
                          ElevatedButton.icon(
                            onPressed: _placeOrder,
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text("Place Order"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
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
  }
}
