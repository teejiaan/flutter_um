import 'package:flutter/material.dart';

class TextLogoRow extends StatelessWidget {
  final String amount;
  final String sponsor;
  final String sponsorLogoAsset;

  const TextLogoRow({
    super.key,
    required this.amount,
    required this.sponsor,
    required this.sponsorLogoAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text content
            Expanded(
              child: Text(
                "The total proceedings this month has accumulated to $amount and we are very grateful to our loyal customers supporting the community and the needy! "
                "Be sure to tune in every month to check which other charities we will be providing for! This section is sponsored by $sponsor.",
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(width: 12),
            // Logo image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                sponsorLogoAsset,
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
