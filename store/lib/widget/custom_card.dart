// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:store/models/prodect_model.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String price;
  final String image;
  final Product_model product;

  const CustomCard({
    super.key,
    required this.title,
    required this.price,
    required this.image,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardImageHeight = screenWidth * 0.4; // نسبة من العرض
    final smallFont = screenWidth * 0.025; // حجم خط صغير ديناميكي
    final iconSize = screenWidth * 0.05;

    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المنتج
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              image,
              height: cardImageHeight,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            ),
          ),

          // محتوى المنتج
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        (product.title != null && product.title!.length > 6)
                            ? '${product.title!.substring(0, 6)}...'
                            : (product.title ?? ''),
                        style: TextStyle(
                          fontSize: smallFont,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Text(
                      price,
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: smallFont + 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: iconSize * 2,
                    width: iconSize * 2,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 2),
                      ],
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: iconSize,
                      onPressed: () {
                        // تنفيذ إضافة للسلة
                      },
                      icon: const FaIcon(FontAwesomeIcons.cartShopping),
                      color: Colors.black87,
                    ),
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
