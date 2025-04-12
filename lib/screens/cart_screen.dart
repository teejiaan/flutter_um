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

    double totalPrice = cart.items.fold(
      0.0,
      (sum, item) => sum + item.price * item.quantity,
    );

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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Size: ${item.size}'),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              if (item.quantity == 1) {
                                final shouldDelete = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (ctx) => AlertDialog(
                                        title: const Text("Remove Item"),
                                        content: const Text(
                                          "Remove this item from cart?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(ctx, false),
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(ctx, true),
                                            child: const Text("Remove"),
                                          ),
                                        ],
                                      ),
                                );

                                if (shouldDelete == true) {
                                  cart.removeItem(item);
                                }
                              } else {
                                cart.updateQuantity(item, item.quantity - 1);
                              }
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Text(item.quantity.toString()),
                          IconButton(
                            onPressed: () {
                              cart.updateQuantity(item, item.quantity + 1);
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Text(
                    'RM ${(item.price * item.quantity).toStringAsFixed(2)}',
                  ),
                );
              },
            ),
          ),

          // Total Price
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'RM ${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Checkout Button
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoMono',
                ),
              ),
              child: const Text("Checkout"),
            ),
          ),
        ],
      ),
    );
  }
}
