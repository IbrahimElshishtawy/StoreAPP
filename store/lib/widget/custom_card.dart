// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:store/models/prodect_model.dart';
import 'package:store/widget/items_cart_product.dart';

class CustomCard extends StatefulWidget {
  final String title;
  final String price;
  final String image;
  final ProductModel product;

  const CustomCard({
    super.key,
    required this.title,
    required this.price,
    required this.image,
    required this.product,
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool isFavorited = false;

  void toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
    });
  }

  void addToCart() {
    final cart = Provider.of<CartProvider>(context, listen: false);
    cart.addItem(widget.product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✅ Added to cart'),
        action: SnackBarAction(
          label: 'Go to cart',
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------------- Stack للصورة + القلب ----------------------
          Stack(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    widget.image,
                    height: 100,
                    width: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 40),
                  ),
                ),
              ),

              // زر القلب في أعلى اليمين
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: toggleFavorite,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ---------------------- التفاصيل ----------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم المنتج
                Text(
                  widget.title.length > 30
                      ? '${widget.title.substring(0, 30)}...'
                      : widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),

                // وصف مختصر
                Text(
                  widget.product.description?.split(' ').first ?? '',
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 12),

                // السعر + السلة
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: addToCart,
                      icon: const FaIcon(
                        FontAwesomeIcons.cartShopping,
                        color: Colors.teal,
                      ),
                    ),
                    Text(
                      '\$${widget.price}',
                      style: const TextStyle(
                        color: Colors.teal,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
