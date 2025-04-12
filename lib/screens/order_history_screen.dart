import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:open_file/open_file.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<DocumentSnapshot> orders = [];
  List<List<dynamic>> orderData = [];

  // Load orders from Firestore for the current user
  Future<void> loadOrderData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return; // No user logged in
    }

    final orderSnapshots =
        await FirebaseFirestore.instance
            .collection('OrderHistory')
            .where('UserId', isEqualTo: userId)
            .get();

    setState(() {
      orders = orderSnapshots.docs;
    });
  }

  @override
  void initState() {
    super.initState();
    loadOrderData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          orders.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index].data() as Map<String, dynamic>;
                  final transactionID = order['TransactionID'];
                  final paid = order['Amount'];
                  final date = order['Date'];

                  // 'Product' is a map, so we can iterate over its entries
                  final Map<String, dynamic> productMap =
                      Map<String, dynamic>.from(order['Product']);
                  final productNames =
                      productMap.keys.toList(); // List of product names
                  final productQuantities =
                      productMap.values.toList(); // List of quantities

                  // Example: Accessing the first product's name and quantity
                  final firstProduct =
                      productNames.isNotEmpty ? productNames[0] : 'No Product';
                  final firstQuantity =
                      productQuantities.isNotEmpty ? productQuantities[0] : 0;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        'Transaction ID: $transactionID',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Paid: RM ${paid != null ? double.parse(paid.toString()).toStringAsFixed(2) : "0.00"}',
                          ),

                          Text('Date: $date'),
                          for (int i = 0; i < productNames.length; i++)
                            Text('${productNames[i]}: ${productQuantities[i]}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.picture_as_pdf,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          generatePDF(order);
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }

  // Generate a PDF report for the order
  Future<void> generatePDF(Map<String, dynamic> order) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build:
            (pw.Context context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Receipt',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Transaction ID: ${order['TransactionID']}'),
                pw.Text('Date: ${order['Date']}'),
                pw.Text('Paid: RM ${order['Amount'].toStringAsFixed(2)}'),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Items:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 10),
                ...order['Product'].entries.map((entry) {
                  final productName = entry.key;
                  final quantity = entry.value;
                  return pw.Row(
                    children: [
                      pw.Expanded(child: pw.Text(productName)),
                      pw.Text(
                        'x$quantity',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                  );
                }).toList(),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Total Paid: RM ${order['Amount'].toStringAsFixed(2)}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
      ),
    );

    // Save the file
    final outputDir = await getApplicationDocumentsDirectory();
    final file = File(
      '${outputDir.path}/receipt_${order['TransactionID']}.pdf',
    );
    await file.writeAsBytes(await pdf.save());

    print("PDF saved to: ${file.path}");
  }
}
