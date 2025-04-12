import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_um/models/cart_item.dart';
import 'package:intl/intl.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<void> register(String email, String password) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user!.uid;

    // Create a document in Firestore with default values
    await _db.collection('user').doc(uid).set({
      'email': email,
      'daysCheckedIn': 0,
      'membership': false,
      'points': 0,
    });
  }

  // Optional: fetch user data later
  Future<DocumentSnapshot> getUserData(String uid) {
    return _db.collection('user').doc(uid).get();
  }

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Shop screen product view

  // User Data
  Future<void> saveUserInfo(String uid, Map<String, dynamic> data) {
    return _db.collection('user').doc(uid).set(data, SetOptions(merge: true));
  }

  // Cart
  Future<void> addToCart(String uid, String productId, int qty) {
    return _db
        .collection('user')
        .doc(uid)
        .collection('cart')
        .doc(productId)
        .set({'quantity': qty});
  }

  // Method to add an order to the OrderHistory collection
  Future<void> addOrder({
    required String userId,
    required double paid,
    required List<dynamic> items,
    required String organization,
    required String paymentMethod,
  }) async {
    Map<String, int> productMap = {
      for (var item in items) item.name: item.quantity,
    };

    try {
      // Generate a unique TransactionID (could use a timestamp or UUID)
      String transactionId = DateTime.now().millisecondsSinceEpoch.toString();

      // Get the current date and time
      String formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());
      String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Add order to the Firestore OrderHistory collection
      await _db.collection('OrderHistory').add({
        'TransactionID': transactionId,
        'UserId': userId,
        'Product': productMap, // ✅ Product names with quantities
        'Amount': items.fold<double>(
          0.0,
          (sum, item) => sum + (item.price * item.quantity),
        ), // Calculate total amount
        'Organisation': organization,
        'Paid(RM)': paid,
        'PointsAdded': (paid / 10).round(), // Example logic to calculate points
        'Time': formattedTime,
        'Date': formattedDate,
        'PaymentMethod': paymentMethod,
        'ReceiptID':
            'Receipt_${transactionId}', // Example, could be more sophisticated
        'Donated': false, // Assuming donation hasn't been completed by default
      });

      print('Order added successfully');
    } catch (e) {
      print('Error adding order: $e');
    }
  }

  // Products
  Future<void> purchaseProduct(String productId, int quantity) async {
    final ref = _db.collection('items').doc(productId);
    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(ref);
      final stock = snapshot['stock'];
      if (stock >= quantity) {
        transaction.update(ref, {'stock': stock - quantity});
      } else {
        throw Exception('Not enough stock!');
      }
    });
  }

  Stream<QuerySnapshot> getItems() {
    return FirebaseFirestore.instance.collection('items').snapshots();
  }

  Stream<QuerySnapshot> getProducts() {
    return _db.collection('items').snapshots();
  }

  Future<double> calculateMonthlyDonation() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('OrderHistory').get();
    double totalAmount = 0.0;

    for (var doc in snapshot.docs) {
      final amount = doc['Amount'];
      if (amount is int) {
        totalAmount += amount.toDouble();
      } else if (amount is double) {
        totalAmount += amount;
      }
    }

    return totalAmount * 0.7; // Return 70%
  }

  Future<void> updateUserPoints(String uid, int points) async {
    await _db.collection('user').doc(uid).update({
      'points': FieldValue.increment(points),
    });
  }

  Future<void> updateUserMembership(String uid, bool membership) async {
    await _db.collection('user').doc(uid).update({'membership': membership});
  }

  Future<void> updateUserDaysCheckedIn(String uid, int daysCheckedIn) async {
    await _db.collection('user').doc(uid).update({
      'daysCheckedIn': daysCheckedIn,
    });
  }
}
