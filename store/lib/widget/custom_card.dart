import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';
import 'package:store/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:store/features/cart/presentation/bloc/cart_event.dart';
import 'package:store/features/cart/domain/entities/cart_item.dart';

class CustomCard extends StatefulWidget {
  final String title;
  final String price;
  final String image;
  final dynamic product; // Accepts both ProductModel and ProductEntity

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
    ProductEntity productEntity;
    if (widget.product is ProductEntity) {
      productEntity = widget.product;
    } else {
      // Basic mapping if it's the old ProductModel
      productEntity = ProductEntity(
        id: widget.product.id,
        title: widget.product.title ?? '',
        description: widget.product.description ?? '',
        price: widget.product.price ?? 0.0,
        image: widget.product.imageUrl ?? '',
        category: '',
        rating: 0.0,
        ratingCount: 0,
      );
    }

    context.read<CartBloc>().add(AddToCart(CartItem(product: productEntity, quantity: 1)));

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
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 40),
                  ),
                ),
              ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(height: 12),
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
                      widget.price,
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
