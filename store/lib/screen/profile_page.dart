// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:store/models/customs_userid.dart';

class ProfilePage extends StatefulWidget {
  final UserProfile user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserProfile updatedUser;

  @override
  void initState() {
    super.initState();
    updatedUser = widget.user;
    if (kDebugMode) {
      print("🧾 ProfilePage opened");
      print("👤 User Data: ${updatedUser.firstName} ${updatedUser.lastName}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreenAccent, Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: 'Edit Profile',
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                '/editProfile',
                arguments: updatedUser,
              );

              if (result != null && result is Map<String, dynamic>) {
                setState(() {
                  updatedUser = UserProfile(
                    id: updatedUser.id,
                    firstName: result['firstName'] ?? updatedUser.firstName,
                    lastName: result['lastName'] ?? updatedUser.lastName,
                    email: result['email'] ?? updatedUser.email,
                    phone: result['phone'] ?? updatedUser.phone,
                    address: result['address'] ?? updatedUser.address,
                    password: updatedUser.password,
                    imageUrl: result['imageUrl'] ?? updatedUser.imageUrl,
                  );
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              backgroundImage: updatedUser.imageUrl != null
                  ? NetworkImage(updatedUser.imageUrl!)
                  : const AssetImage('assets/image/images.png')
                        as ImageProvider,
            ),
            const SizedBox(height: 16),
            Text(
              '${updatedUser.firstName} ${updatedUser.lastName}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              updatedUser.email,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),
            buildInfoCard(Icons.phone, 'Phone', updatedUser.phone),
            buildInfoCard(Icons.location_on, 'Address', updatedUser.address),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard(IconData icon, String title, String value) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF0D47A1), size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
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
