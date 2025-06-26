// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

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

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  bool isPickingImage = false;

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

  Future<void> uploadProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final name = nameController.text.trim();
    final description = descriptionController.text.trim();
    final price = double.tryParse(priceController.text.trim());

    if (price == null) {
      showSnack("Invalid price");
      return;
    }

    if (_selectedImage == null) {
      showSnack("Please select an image", color: Colors.orange);
      return;
    }

    setState(() => isLoading = true);

    try {
      final imageUrl = await uploadImageToFirebase(_selectedImage!);

      await FirebaseFirestore.instance.collection('products').add({
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'createdAt': Timestamp.now(),
      });

      showSnack("✅ Product uploaded successfully", color: Colors.green);
      nameController.clear();
      descriptionController.clear();
      priceController.clear();
      setState(() => _selectedImage = null);
    } catch (e) {
      showSnack("Error uploading product: $e", color: Colors.red);
    } finally {
      setState(() => isLoading = false);
    }
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
            _selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _selectedImage!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
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
    return InkWell(
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
              Expanded(
                child: Text(
                  _selectedImage != null
                      ? "Tap to change the image"
                      : "Tap to select an image",
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Product"),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
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
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter product name' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: "Description"),
                    onChanged: (_) => setState(() {}),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter description' : null,
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
      ),
    );
  }
}
