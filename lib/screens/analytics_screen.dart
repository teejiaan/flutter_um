import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatelessWidget {
   AnalyticsScreen({super.key});

  final double totalAmount = 2150.0; // Mock total purchase amount

  final List<String> organizations = [
    'Yayasan Kebajikan Negara',
    'Hospis Malaysia',
    'National Kidney Foundation of Malaysia',
    'UNICEF Malaysia',
    'PERTIWI Soup Kitchen',
    'Yayasan ChowKit',
  ];

  final List<Color> pieColors = [
    Colors.teal,
    Colors.orange,
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.redAccent,
  ];

  final List<double> percentages = [30, 20, 15, 10, 15, 10];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: Colors.teal,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Total Purchase Amount: RM ${totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            AspectRatio(
              aspectRatio: 1.3,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 50,
                  sections: List.generate(6, (i) {
                    return PieChartSectionData(
                      color: pieColors[i],
                      value: percentages[i],
                      title: '${percentages[i]}%',
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Legend',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...List.generate(organizations.length, (index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: pieColors[index],
                  radius: 8,
                ),
                title: Text(organizations[index]),
              );
            }),
          ],
        ),
      ),
    );
  }
}
