import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_um/models/cart_item.dart';
import 'package:flutter_um/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class PurchaseMembershipScreen extends StatelessWidget {
  const PurchaseMembershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final benefits = [
      "🎁 Free 200 points to start",
      "✅ Collect more points when checking in",
      "🔥 Get 3x more points when purchasing items",
      "🛍️ Exclusive member-only deals",
      "⭐ Priority support and feedback access",
      "💳 Early access to special events",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership Benefits'),
        backgroundColor: Colors.teal,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Why Become a Member?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...benefits.map(
              (benefit) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(benefit, style: const TextStyle(fontSize: 16)),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: const Icon(Icons.shopping_cart_checkout),
                label: const Text(
                  'Purchase Membership',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  final userId = FirebaseAuth.instance.currentUser?.uid;
                  if (userId == null) return;

                  final userDoc =
                      await FirebaseFirestore.instance
                          .collection('user')
                          .doc(userId)
                          .get();
                  final hasMembership = userDoc.data()?['membership'] ?? false;

                  if (!hasMembership) {
                    // Add membership to cart
                    final membershipItem = CartItem(
                      id: 'membership',
                      name: 'Membership',
                      imageUrl:
                          'assets/membership.png', // Replace with your asset or URL
                      price: 24.00,
                      quantity: 1,
                      size: 'Standard', // Optional if needed by your model
                    );

                    Provider.of<CartProvider>(
                      context,
                      listen: false,
                    ).addToCart(membershipItem);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Membership added to cart!'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('You already have an active membership.'),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
