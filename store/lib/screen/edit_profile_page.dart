// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store/models/customs_userid.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfile user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController passwordController;

  File? _profileImage;
  String? _imageUrl;
  bool isLoading = false;
  bool showPassword = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.user.firstName);
    lastNameController = TextEditingController(text: widget.user.lastName);
    emailController = TextEditingController(text: widget.user.email);
    phoneController = TextEditingController(text: widget.user.phone);
    addressController = TextEditingController(text: widget.user.address);
    passwordController = TextEditingController();
    _imageUrl = widget.user.imageUrl;
  }

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      final uid = widget.user.id;
      final ref = FirebaseStorage.instance.ref().child(
        'profile_images/$uid.jpg',
      );
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Failed to upload image: $e')));
      return null;
    }
  }

  Future<void> updateProfile() async {
    setState(() => isLoading = true);
    try {
      final uid = widget.user.id;
      final currentUser = FirebaseAuth.instance.currentUser;

      // Upload new image if selected
      if (_profileImage != null) {
        final url = await uploadImage(_profileImage!);
        if (url != null) _imageUrl = url;
      }

      // Update Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        if (_imageUrl != null) 'profileImage': _imageUrl,
      });

      // Update Firebase Auth email/password if changed
      if (emailController.text.trim() != currentUser?.email &&
          currentUser != null) {
        await currentUser.updateEmail(emailController.text.trim());
      }

      if (passwordController.text.trim().isNotEmpty && currentUser != null) {
        await currentUser.updatePassword(passwordController.text.trim());
      }

      Navigator.pop(context, {
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'imageUrl': _imageUrl,
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Failed to update: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  ImageProvider getImageProvider() {
    if (_profileImage != null) {
      return FileImage(_profileImage!);
    } else if (_imageUrl != null && _imageUrl!.isNotEmpty) {
      return NetworkImage(_imageUrl!);
    } else {
      return const AssetImage('assets/image/images.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: getImageProvider(),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.blue,
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            buildTextField('First Name', firstNameController),
            buildTextField('Last Name', lastNameController),
            buildTextField(
              'Email',
              emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            buildTextField(
              'Phone',
              phoneController,
              keyboardType: TextInputType.phone,
            ),
            buildTextField('Address', addressController),
            buildTextField(
              'New Password (optional)',
              passwordController,
              obscure: !showPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () => setState(() => showPassword = !showPassword),
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: updateProfile,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'Save Changes',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2B9FD9),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
