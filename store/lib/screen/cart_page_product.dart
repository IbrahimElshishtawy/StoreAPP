// ignore_for_file: unnecessary_underscores
import 'package:flutter/material.dart';
import 'package:store/models/prodect_model.dart';
import 'package:store/widget/items_cart_product.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void _incrementQuantity(String productId) {
    setState(() {
      cartQuantities[productId] = (cartQuantities[productId] ?? 1) + 1;
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
      }
    });
  }

  double get totalPrice {
    double total = 0.0;
    for (var product in cartItems) {
      final qty = cartQuantities[product.id] ?? 1;
      total += ((product.price ?? 0) * qty);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cartItems.isEmpty
          ? const Center(child: Text('The cart is empty '))
          : Column(
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
                            child: Image.network(
                              product.imageUrl ?? '',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
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
                                onPressed: () => _decrementQuantity(product.id),
                              ),
                              Text(
                                quantity.toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => _incrementQuantity(product.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: const Border(
                      top: BorderSide(color: Colors.black12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total : \$',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
