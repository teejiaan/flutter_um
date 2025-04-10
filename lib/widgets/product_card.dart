import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final int index;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  final String selectedSize;
  final List<String> availableSizes;
  final void Function(int) onQuantityChanged;
  final void Function(String) onSizeChanged;
  final VoidCallback onBuy;

  const ProductCard({
    super.key,
    required this.index,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.selectedSize,
    required this.availableSizes,
    required this.onQuantityChanged,
    required this.onSizeChanged,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 255, 255, 255),
      shadowColor: const Color.fromARGB(255, 165, 159, 159).withOpacity(0.2),
      elevation: 3,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT SIDE
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Image.asset(
                    'assets/$imageUrl',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    children:
                        availableSizes.map((size) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio<String>(
                                value: size,
                                groupValue: selectedSize,
                                onChanged: (value) => onSizeChanged(value!),
                              ),
                              Text(size),
                            ],
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // RIGHT SIDE
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => onQuantityChanged(-1),
                        icon: const Icon(Icons.remove),
                      ),
                      Text(
                        quantity.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        onPressed: () => onQuantityChanged(1),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "RM ${price.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: onBuy,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Buy"),
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
