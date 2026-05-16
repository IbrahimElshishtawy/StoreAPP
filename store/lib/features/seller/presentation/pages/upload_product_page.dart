// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:store/features/seller/presentation/bloc/seller_bloc.dart';
import 'package:store/features/seller/presentation/bloc/seller_event.dart';
import 'package:store/features/seller/presentation/bloc/seller_state.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';

class UploadProductPage extends StatefulWidget {
  const UploadProductPage({super.key});

  @override
  State<UploadProductPage> createState() => _UploadProductPageState();
}

class _UploadProductPageState extends State<UploadProductPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final urlController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  bool isPickingImage = false;
  bool useUrlInstead = false;

  void showSnack(String message, {Color? color}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  Future<void> pickImage() async {
    if (isPickingImage) return;
    setState(() => isPickingImage = true);
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() => _selectedImage = File(pickedFile.path));
      }
    } catch (e) {
      showSnack("❌ Error picking image: $e", color: Colors.red);
    } finally {
      setState(() => isPickingImage = false);
    }
  }

  Future<String> uploadImageToFirebase(File file) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance.ref().child(
      'product_images/$fileName.jpg',
    );
    final uploadTask = await ref.putFile(file);
    return await uploadTask.ref.getDownloadURL();
  }

  void uploadProduct() {
    if (!_formKey.currentState!.validate()) return;

    final name = nameController.text.trim();
    final description = descriptionController.text.trim();
    final price = double.tryParse(priceController.text.trim()) ?? 0.0;

    String? imageUrl;
    if (useUrlInstead) {
      imageUrl = urlController.text.trim();
      if (imageUrl.isEmpty) {
        showSnack("Please enter image URL", color: Colors.orange);
        return;
      }
    } else {
      if (_selectedImage == null) {
        showSnack("Please select an image", color: Colors.orange);
        return;
      }
      // For simplicity in this mock, we use the local path as a URL
      imageUrl = _selectedImage!.path;
    }

    final product = ProductEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: name,
      description: description,
      price: price,
      image: imageUrl,
      category: "seller_upload",
    );

    context.read<SellerBloc>().add(AddProductRequested(product));
  }

  Widget buildProductCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (!useUrlInstead && _selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _selectedImage!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else if (useUrlInstead && urlController.text.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  urlController.text,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Text("No image selected")),
              ),
            const SizedBox(height: 10),
            Text(
              nameController.text.isEmpty
                  ? "Product Name"
                  : nameController.text,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              descriptionController.text.isEmpty
                  ? "Product description will show here"
                  : descriptionController.text,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Text(
              priceController.text.isEmpty
                  ? "Price"
                  : "\$${priceController.text}",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ChoiceChip(
              label: const Text("Upload Image"),
              selected: !useUrlInstead,
              onSelected: (_) => setState(() => useUrlInstead = false),
            ),
            const SizedBox(width: 10),
            ChoiceChip(
              label: const Text("Use Image URL"),
              selected: useUrlInstead,
              onSelected: (_) => setState(() => useUrlInstead = true),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (!useUrlInstead)
          InkWell(
            onTap: pickImage,
            borderRadius: BorderRadius.circular(12),
            child: DottedBorder(
              child: Container(
                width: double.infinity,
                height: 90,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade100,
                ),
                child: Row(
                  children: [
                    _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _selectedImage!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.image_outlined,
                            size: 60,
                            color: Colors.grey,
                          ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        "Tap to select an image",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          TextFormField(
            controller: urlController,
            decoration: const InputDecoration(labelText: "Image URL"),
            validator: (value) {
              if (useUrlInstead && (value == null || value.isEmpty)) {
                return 'Please enter a valid image URL';
              }
              return null;
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SellerBloc, SellerState>(
      listener: (context, state) {
        if (state is SellerInitial) {
           showSnack("✅ Product uploaded successfully", color: Colors.green);
           Navigator.pop(context);
        } else if (state is SellerError) {
          showSnack(state.message, color: Colors.red);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Upload Product"),
          backgroundColor: Colors.blue[800],
        ),
        body: BlocBuilder<SellerBloc, SellerState>(
          builder: (context, state) {
            final isLoading = state is SellerLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildProductCard(),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildImagePicker(),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: "Product Name",
                          ),
                          onChanged: (_) => setState(() {}),
                          validator: (value) => value!.isEmpty
                              ? 'Please enter product name'
                              : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: descriptionController,
                          decoration:
                              const InputDecoration(labelText: "Description"),
                          onChanged: (_) => setState(() {}),
                          validator: (value) => value!.isEmpty
                              ? 'Please enter description'
                              : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: priceController,
                          decoration: const InputDecoration(labelText: "Price"),
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter price' : null,
                        ),
                        const SizedBox(height: 20),
                        isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: uploadProduct,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[800],
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 40,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "Upload Product",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
