import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<DocumentSnapshot> orderData = [];

  @override
  void initState() {
    super.initState();
    loadOrderData();
  }

  Future<void> loadOrderData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final query =
        await FirebaseFirestore.instance
            .collection('OrderHistory')
            .where('UserId', isEqualTo: userId)
            .get();

    setState(() {
      orderData = query.docs;
    });
  }

  Future<void> _generateTransactionReport(Map<String, dynamic> order) async {
    final pdf = pw.Document();

    final productMap = Map<String, dynamic>.from(order['Product'] ?? {});
    final date = order['Date'] ?? '';
    final time = order['Time'] ?? '';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Transaction Receipt',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              _buildDetailRow('Transaction ID:', order['TransactionID'] ?? ''),
              _buildDetailRow('User ID:', order['UserId'] ?? ''),
              _buildDetailRow(
                'Paid (RM):',
                (order['Paid(RM)'] ?? 0).toString(),
              ),
              _buildDetailRow('Date:', date),
              _buildDetailRow('Time:', time),
              _buildDetailRow('Payment Method:', order['PaymentMethod'] ?? ''),
              _buildDetailRow('Receipt ID:', order['ReceiptID'] ?? ''),
              _buildDetailRow('Organization:', order['Organization'] ?? ''),
              pw.SizedBox(height: 20),
              pw.Text(
                'Products:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 8),
              ...productMap.entries.map((e) => pw.Text('${e.key}: ${e.value}')),
              pw.Spacer(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Generated on: ${DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now())}',
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
                ),
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File(
      '${output.path}/transaction_${order['TransactionID']}.pdf',
    );
    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);

    await Share.shareXFiles([
      XFile(file.path),
    ], text: 'Transaction Report - ${order['TransactionID']}');
  }

  pw.Widget _buildDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 130,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(child: pw.Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        backgroundColor: Colors.teal,
      ),
      body:
          orderData.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: orderData.length,
                itemBuilder: (context, index) {
                  final order = orderData[index].data() as Map<String, dynamic>;
                  final transactionID = order['TransactionID'] ?? 'N/A';
                  final paid = (order['Paid(RM)'] ?? 0).toDouble();
                  final date = order['Date'] ?? '';
                  final productMap = Map<String, dynamic>.from(
                    order['Product'] ?? {},
                  );
                  final firstProduct =
                      productMap.entries.isNotEmpty
                          ? productMap.entries.first
                          : const MapEntry('No Product', 0);

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
                          Text('Product: ${firstProduct.key}'),
                          Text('Quantity: ${firstProduct.value}'),
                          Text('Total Paid: RM ${paid.toStringAsFixed(2)}'),
                          Text('Date: $date'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.picture_as_pdf,
                          color: Colors.teal,
                        ),
                        onPressed: () => _generateTransactionReport(order),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
