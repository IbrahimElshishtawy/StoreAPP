// ignore_for_file: prefer_interpolation_to_compose_strings, deprecated_member_use, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:store/models/prodect_model.dart';
import 'package:store/screen/updata_product_page.dart';

class CustomCard extends StatelessWidget {
  final Product_model product;

  const CustomCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          UpdataProductPage.id,
          arguments: {
            'id': product.id,
            'title': product.title,
            'price': product.price.toString(),
            'description': product.description,
            'image': product.imageUrl,
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
                  offset: Offset(10, 10),
                ),
              ],
            ),
            child: Container(
              width: double.infinity,
              height: 120,
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
                        (product.title ?? '').length > 20
                            ? (product.title ?? '').substring(0, 15) + '...'
                            : (product.title ?? ''),
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${product.price}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          Icon(Icons.favorite, color: Colors.red),
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
                product.imageUrl ?? '',
                height: 110,
                width: 80,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
