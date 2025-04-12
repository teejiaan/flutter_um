import 'package:flutter/material.dart';

class TextLogoRow extends StatelessWidget {
  final String amount;
  final String sponsor;
  final String Charity;
  final String CharityLogoAsset;
  final String sponsorLogoAsset;

  const TextLogoRow({
    super.key,
    required this.amount,
    required this.sponsor,
    required this.Charity,
    required this.CharityLogoAsset,
    required this.sponsorLogoAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 TOP HEADER: Charity Name & Logo (OUTSIDE the box)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Charity Name
              Expanded(
                child: Text(
                  Charity,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Charity Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  CharityLogoAsset,
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24), // Space between header and box
          // 🔸 DESCRIPTION BOX BELOW
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text:
                        "The total proceedings this month is $amount and we are very grateful to our loyal customers supporting the community! "
                        "Tune in every month to check which other charities we will be providing for! This month's contribution is sponsored by ",
                  ),
                  TextSpan(
                    text: sponsor,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: "."),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
