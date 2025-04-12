import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_um/services/firebase_service.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return ListTile(
                  leading: Image.asset('assets/${item.imageUrl}', height: 40),
                  title: Text(item.name),
                  subtitle: Text('Size: ${item.size} | Qty: ${item.quantity}'),
                  trailing: Text(
                    'RM ${(item.price * item.quantity).toStringAsFixed(2)}',
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (ctx) => AlertDialog(
                      title: const Text("Confirm Purchase"),
                      content: const Text(
                        "Do you want to complete the purchase?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text("No"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
              );

              if (confirm == true) {
                final firebaseService = FirebaseService();
                for (var item in cart.items) {
                  // Update stock
                  final querySnapshot =
                      await FirebaseFirestore.instance
                          .collection('items')
                          .where('name', isEqualTo: item.name)
                          .get();

                  if (querySnapshot.docs.isNotEmpty) {
                    final doc = querySnapshot.docs.first;
                    final stock = doc['stock'];
                    if (stock >= item.quantity) {
                      await firebaseService.purchaseProduct(
                        doc.id,
                        item.quantity,
                      );
                    }
                  }
                }

                cart.clearCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Purchase successful!")),
                );
              }
            },
            child: const Text("Checkout"),
          ),
        ],
      ),
    );
  }
}
