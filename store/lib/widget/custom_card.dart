// ignore_for_file: deprecated_member_use, sized_box_for_whitespace, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:store/models/prodect_model.dart';
import 'package:store/screen/updata_product_page.dart';
// Make sure UpdateProductPage is defined in updata_product_page.dart and has a static 'id' field.
import 'package:store/widget/items_cart_product.dart';

class CustomCard extends StatefulWidget {
  final Product_model product;

  const CustomCard({super.key, required this.product});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool isFavorited = false;
  bool isAddedToCart = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          UpdataProductPage.id,
          //    UpdataProductPage.id,
          arguments: {
            'id': widget.product.id,
            'title': widget.product.title,
            'price': widget.product.price.toString(),
            'description': widget.product.description,
            'image': widget.product.imageUrl,
          },
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 70, right: 1, left: 1),
            padding: const EdgeInsets.all(0.01),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 50,
                  offset: const Offset(10, 10),
                ),
              ],
            ),
            child: Container(
              width: double.infinity,
              height: 140,
              child: Card(
                elevation: 7,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        (widget.product.title ?? '').length > 20
                            ? (widget.product.title ?? '').substring(0, 15) +
                                  '...'
                            : (widget.product.title ?? ''),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${widget.product.price}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  isFavorited
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorited ? Colors.red : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isFavorited = !isFavorited;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add_shopping_cart,
                                  color: isAddedToCart
                                      ? Colors.green
                                      : Colors.black54,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isAddedToCart = true;
                                  });

                                  final existingProductIndex = cartItems
                                      .indexWhere(
                                        (item) => item.id == widget.product.id,
                                      );

                                  if (existingProductIndex == -1) {
                                    cartItems.add(widget.product);
                                    cartQuantities[widget.product.id] = 1;
                                  } else {
                                    cartQuantities[widget.product.id] =
                                        (cartQuantities[widget.product.id] ??
                                            1) +
                                        1;
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'تمت إضافة المنتج إلى السلة ✅',
                                      ),
                                      duration: Duration(seconds: 1),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 40,
            top: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.product.imageUrl ?? '',
                height: 110,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UpdataProductPage {
  static String id = '';
}
