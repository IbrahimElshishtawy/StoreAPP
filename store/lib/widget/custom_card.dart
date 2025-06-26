// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:store/models/prodect_model.dart';

class CustomCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final cardImageHeight = screenWidth * 0.4;

        // حجم خط آمن
        final smallFont = screenWidth * 0.035 < 12 ? 12.0 : screenWidth * 0.035;
        final iconSize = screenWidth * 0.07;

        return Card(
          margin: const EdgeInsets.all(6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          color: const Color(0xFFF8F4FF), // لون خلفية خفيف
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  image,
                  height: cardImageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 40),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            (product.title != null &&
                                    product.title!.length > 12)
                                ? '${product.title!.substring(0, 12)}...'
                                : (product.title ?? ''),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: smallFont,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          price,
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: smallFont + 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: iconSize * 1.6,
                        width: iconSize * 1.6,
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
      },
    );
  }
}
