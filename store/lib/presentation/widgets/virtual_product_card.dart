import 'package:flutter/material.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';

class VirtualProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onVrTap;

  const VirtualProductCard({
    super.key,
    required this.product,
    required this.onVrTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    color: const Color(0xFFF5F7FA),
                    image: DecorationImage(
                      image: NetworkImage(product.imageUrl),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: onVrTap,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.view_in_ar,
                        color: Color(0xFF0A192F),
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(
                            ' ${product.rating}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
