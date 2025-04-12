import 'dart:io';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

Future<void> appendOrderToCSV({
  required String product,
  required int amount,
  required String organization,
  required double paid,
  required int pointsAdded,
  required bool donated,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final dir = await getApplicationDocumentsDirectory();
  final path = '${dir.path}/OrderHistory.csv';
  final file = File(path);

  final now = DateTime.now();
  final uuid = const Uuid();

  final row = [
    uuid.v4(), // Transaction ID
    user.uid, // User ID
    product,
    amount,
    organization,
    paid.toStringAsFixed(2),
    pointsAdded,
    DateFormat('HH:mm:ss').format(now),
    DateFormat('yyyy-MM-dd').format(now),
    'Online', // Default Payment Method
    uuid.v4(), // Receipt ID
    donated ? 'Yes' : 'No',
  ];

  // If file doesn't exist, create it with header
  if (!await file.exists()) {
    await file.writeAsString(
      const ListToCsvConverter().convert([
        [
          'TransactionID',
          'UserId',
          'Product',
          'Amount',
          'Organization',
          'Paid(RM)',
          'Points Added',
          'Time',
          'Date',
          'PaymentMethod',
          'ReceiptID',
          'Donated',
        ],
      ]),
      mode: FileMode.write,
    );
    await file.writeAsString('\n', mode: FileMode.append);
  }

  final csvRow = const ListToCsvConverter().convert([row]);
  await file.writeAsString('$csvRow\n', mode: FileMode.append);
}
