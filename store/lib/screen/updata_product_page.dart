// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:store/service/updata_product.dart';
import 'package:store/widget/custom_btn.dart';
import 'package:store/widget/custom_textfeld.dart';

class UpdataProductPage extends StatefulWidget {
  const UpdataProductPage({super.key});
  static String id = 'updataProductPage';

  @override
  State<UpdataProductPage> createState() => _UpdataProductPageState();
}

class _UpdataProductPageState extends State<UpdataProductPage> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController imageUrlController;

  Map<String, dynamic>? product;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      product = args;
      nameController = TextEditingController(text: product!['title']);
      priceController = TextEditingController(
        text: product!['price'].toString(),
      );
      descriptionController = TextEditingController(
        text: product!['description'],
      );
      imageUrlController = TextEditingController(text: product!['image']);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return const Scaffold(body: Center(child: Text("No product data found")));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Update Product',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// 👇 نموذج تعديل البيانات
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 6,
                shadowColor: Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        height: 320,
                        width: double.infinity,
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// الصورة في الأعلى
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Center(
                                  child: Image.network(
                                    imageUrlController.text,
                                    width: 120,
                                    height: 160,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const SizedBox(
                                              height: 160,
                                              child: Center(
                                                child: Icon(
                                                  Icons.broken_image,
                                                  size: 50,
                                                ),
                                              ),
                                            ),
                                  ),
                                ),
                              ),

                              /// المحتوى النصي
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// الاسم
                                    Text(
                                      nameController.text,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),

                                    /// الوصف
                                    Text(
                                      descriptionController.text,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 12),

                                    /// السعر جهة اليسار
                                    Row(
                                      children: [
                                        const Spacer(),
                                        Text(
                                          '\$${priceController.text}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.green,
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
                        ),
                      ),

                      SizedBox(height: 10),
                      CustomTextField(
                        hintext: 'Product Name',
                        controller: nameController,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        hintext: 'Product Price',
                        Keyboard: TextInputType.number,
                        controller: priceController,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        hintext: 'Product Description',
                        controller: descriptionController,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        hintext: 'Product Image URL',
                        controller: imageUrlController,
                      ),
                      const SizedBox(height: 30),

                      /// 👇 زر التحديث
                      CustomBtn(
                        textbtn: 'Update Product',
                        onPressed: (_) async {
                          try {
                            await UpdataProduct().updataProduct(
                              id: product!['id'],
                              title: nameController.text,
                              description: descriptionController.text,
                              price: double.tryParse(priceController.text) ?? 0,
                              image: imageUrlController.text,
                              category: '',
                            );

                            setState(() {}); // ⬅️ يحدث الصفحة

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Product Updated Successfully'),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to update product'),
                              ),
                            );
                          }
                        },
                        data: {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
