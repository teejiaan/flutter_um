import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ManagerScreen extends StatefulWidget {
  const ManagerScreen({super.key});

  @override
  State<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _stockController = TextEditingController();

  File? _pickedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });

      // Upload to Firebase Storage
      final fileName = pickedFile.name;
      final destination = 'item_images/$fileName';
      final ref = FirebaseStorage.instance.ref(destination);

      setState(() => _isUploading = true);

      try {
        await ref.putFile(_pickedImage!);
        final downloadUrl = await ref.getDownloadURL();
        setState(() {
          _imageUrlController.text = downloadUrl;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${e.toString()}')),
        );
      }

      setState(() => _isUploading = false);
    }
  }

  Future<void> _addItemToFirestore() async {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text.trim();
      final double price = double.parse(_priceController.text.trim());
      final String imageUrl = _imageUrlController.text.trim();
      final int stock = int.parse(_stockController.text.trim());

      try {
        await FirebaseFirestore.instance.collection('items').add({
          'name': name,
          'price': price,
          'imageURL': imageUrl,
          'stock': stock,
          'timestamp': FieldValue.serverTimestamp(),
          'availableSizes': [],
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item added successfully')),
        );

        _nameController.clear();
        _priceController.clear();
        _imageUrlController.clear();
        _stockController.clear();
        setState(() => _pickedImage = null);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Panel'),
        backgroundColor: Colors.teal,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text(
                'Manager Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Add New Item',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator:
                    (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price (RM)'),
                keyboardType: TextInputType.number,
                validator:
                    (value) => value!.isEmpty ? 'Please enter a price' : null,
              ),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator:
                    (value) => value!.isEmpty ? 'Please enter stock' : null,
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _isUploading ? null : _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Pick Image from Gallery'),
              ),
              const SizedBox(height: 10),
              if (_pickedImage != null)
                SizedBox(height: 150, child: Image.file(_pickedImage!)),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator:
                    (value) => value!.isEmpty ? 'Image URL missing!' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isUploading ? null : _addItemToFirestore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 14,
                  ),
                ),
                child: const Text('Add Item', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
