import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';
import '../widgets/product_card.dart';
import '../widgets/text_logo_row.dart';
import '../models/cart_item.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<int> quantities = [];
  List<String> selectedSizes = [];

  void updateQuantity(int index, int change) {
    setState(() {
      quantities[index] += change;
      if (quantities[index] < 1) quantities[index] = 1;
    });
  }

  void updateSize(int index, String size) {
    setState(() {
      selectedSizes[index] = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ⬅️ Add your message widget here
            FutureBuilder<double>(
              future: _firebaseService.calculateMonthlyDonation(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();

                final donationAmount = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextLogoRow(
                    Charity: 'Yayasan Kebajikan Negara',
                    CharityLogoAsset: 'assets/yayasan.png',
                    amount: 'RM ${donationAmount.toStringAsFixed(2)}',
                    sponsor: 'Axiata Group',
                    sponsorLogoAsset: 'assets/Axiata_Logo.png',
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // Remove the "return" keyword from here
            StreamBuilder<QuerySnapshot>(
              stream: _firebaseService.getItems(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();

                final items = snapshot.data!.docs;

                // Initialize quantities and selectedSizes if needed
                if (quantities.length != items.length) {
                  quantities = List.generate(
                    items.length,
                    (_) => 1,
                  ); // Default quantity is 1
                }

                if (selectedSizes.length != items.length) {
                  selectedSizes = List.generate(items.length, (index) {
                    // Get the first available size as default or empty string if no sizes
                    final availableSizes = List<String>.from(
                      items[index]['availableSizes'] ?? [],
                    );
                    return availableSizes.isNotEmpty ? availableSizes[0] : '';
                  });
                }

                return Column(
                  children: List.generate(items.length, (index) {
                    final item = items[index];
                    final name = item['name'] as String;
                    final price =
                        (item['price'] is int)
                            ? (item['price'] as int).toDouble()
                            : (item['price'] as double);
                    final imageUrl = item['imageURL'] as String;
                    final sizes = List<String>.from(
                      (item['availableSizes'] as List<dynamic>).map(
                        (e) => e.toString(),
                      ),
                    );

                    final stock = item['stock'] as int;

                    return ProductCard(
                      index: index,
                      name: name,
                      imageUrl: imageUrl,
                      price: price,
                      quantity: quantities[index],
                      selectedSize: selectedSizes[index],
                      availableSizes: sizes,
                      onQuantityChanged:
                          (change) => updateQuantity(index, change),
                      onSizeChanged: (size) => updateSize(index, size),
                      onBuy: () {
                        final cartItem = CartItem(
                          id: item.id,
                          name: name,
                          imageUrl: imageUrl,
                          price: price,
                          quantity: quantities[index],
                          size: selectedSizes[index],
                        );

                        Provider.of<CartProvider>(
                          context,
                          listen: false,
                        ).addToCart(cartItem);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Item added to cart")),
                        );
                      },
                      stocksleft: stock,
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
