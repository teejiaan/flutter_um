import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
}
