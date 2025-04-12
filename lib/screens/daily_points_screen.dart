import 'package:flutter/material.dart';

class DailyPointsScreen extends StatefulWidget {
  const DailyPointsScreen({super.key});

  @override
  State<DailyPointsScreen> createState() => _DailyPointsScreenState();
}

class _DailyPointsScreenState extends State<DailyPointsScreen> {
  int currentPoints = 200;
  bool collectedToday = false;

  void collectPoints() {
    if (!collectedToday) {
      setState(() {
        currentPoints += 20;
        collectedToday = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You've collected 20 points today!")),
      );
    }
  }

  final List<Map<String, dynamic>> rewards = [
    {'title': 'RM5 Voucher', 'cost': 100},
    {'title': '10% Discount Coupon', 'cost': 150},
    {'title': 'Free Shipping Token', 'cost': 80},
    {'title': 'Mystery Gift', 'cost': 200},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Points'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: collectPoints,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    backgroundColor: collectedToday ? Colors.grey : Colors.teal,
                  ),
                  child: const Text(
                    'Collect Daily Points',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.stars, color: Colors.teal),
                      const SizedBox(width: 8),
                      Text(
                        '$currentPoints pts',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Redeem with Points',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: rewards.length,
                itemBuilder: (context, index) {
                  final item = rewards[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(item['title']),
                      subtitle: Text('${item['cost']} pts'),
                      trailing: ElevatedButton(
                        onPressed:
                            currentPoints >= item['cost']
                                ? () {
                                  setState(() {
                                    currentPoints -= item['cost'] as int;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${item['title']} redeemed!',
                                      ),
                                    ),
                                  );
                                }
                                : null,
                        child: const Text('Redeem'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
