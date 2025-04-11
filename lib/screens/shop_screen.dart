import 'package:flutter/material.dart';
import 'package:flutter_um/widgets/text_logo_row.dart';
import '../widgets/product_card.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final List<int> quantities = [1, 1];
  final List<String> sizes = ['M', 'M'];

  void updateQuantity(int index, int change) {
    setState(() {
      quantities[index] = (quantities[index] + change).clamp(1, 99);
    });
  }

  void updateSize(int index, String size) {
    setState(() {
      sizes[index] = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(131, 73, 67, 67),

      body: ListView(
        children: [
          TextLogoRow(
            amount: "RM 4,500.00",
            sponsor: "CommunityMart",
            sponsorLogoAsset: "assets/bank_islam_logo.png",
          ),

          ProductCard(
            index: 0,
            name: "Monthly T-Shirt",
            imageUrl: "Graphic-T-Shirt-PNG.png",
            price: 29.99,
            quantity: quantities[0],
            selectedSize: sizes[0],
            availableSizes: ['S', 'M', 'L', 'XL'],
            onQuantityChanged: (change) => updateQuantity(0, change),
            onSizeChanged: (size) => updateSize(0, size),
            onBuy: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Purchased Monthly T-Shirt in size ${sizes[0]} × ${quantities[0]}",
                  ),
                ),
              );
            },
            stocksleft: 2318,
          ),
          ProductCard(
            index: 1,
            name: "This Month's Sneakers",
            imageUrl: "Sneakers.png",
            price: 159.99,
            quantity: quantities[1],
            selectedSize: sizes[1],
            availableSizes: ['6', '7', '8', '9', '10', '11', '12'],
            onQuantityChanged: (change) => updateQuantity(1, change),
            onSizeChanged: (size) => updateSize(1, size),
            onBuy: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Purchased Sneakers in size ${sizes[1]} × ${quantities[1]}",
                  ),
                ),
              );
            },
            stocksleft: 1239,
          ),
        ],
      ),
    );
  }
}
