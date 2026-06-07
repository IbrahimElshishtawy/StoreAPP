import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store/presentation/widgets/common_ui.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorState(
              message: "Error: ${snapshot.error}",
              onRetry: () {},
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator();
          }

          final orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return const EmptyState(message: "You haven't placed any orders yet.");
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              final items = List<Map<String, dynamic>>.from(order['items']);
              final totalPrice = order['totalPrice'];
              final timestamp = order['timestamp'];
              final orderTime = timestamp is Timestamp ? timestamp.toDate() : DateTime.now();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ExpansionTile(
                  leading: const Icon(Icons.receipt_long, color: Colors.teal),
                  title: Text(
                    "Order #${index + 1}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${items.length} items • \$${totalPrice.toStringAsFixed(2)}\n$orderTime",
                    style: const TextStyle(fontSize: 12),
                  ),
                  children: items.map((item) {
                    return ListTile(
                      title: Text(item['title']),
                      subtitle: Text("Quantity: ${item['quantity']}"),
                      trailing: Text(
                        "\$${(item['price'] as num).toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.teal),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
