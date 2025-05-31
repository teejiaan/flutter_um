import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  File? _selectedImage;
  String? _currentName;
  String? _profileImageUrl;
  bool _isLoading = true;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(user!.uid)
              .get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          _currentName = data['name'] ?? 'Unknown';
          _profileImageUrl = data['profileImage'];
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
        'user_images/${user!.uid}.jpg',
      );
      await storageRef.putFile(imageFile);
      return await storageRef.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveChanges() async {
    try {
      String? newImageUrl = _profileImageUrl;
      if (_selectedImage != null) {
        newImageUrl = await _uploadImage(_selectedImage!);
      }

      final newName =
          _nameController.text.trim().isNotEmpty
              ? _nameController.text.trim()
              : _currentName;

      await FirebaseFirestore.instance.collection('user').doc(user!.uid).update(
        {'name': newName, 'profileImage': newImageUrl},
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      setState(() {
        _currentName = newName;
        _profileImageUrl = newImageUrl;
        _selectedImage = null;
        _nameController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/main');
          },
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back $_currentName!',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'You can tweak your profile here:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Profile picture*',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    _selectedImage != null
                        ? Image.file(_selectedImage!, height: 100)
                        : (_profileImageUrl != null
                            ? Image.network(_profileImageUrl!, height: 100)
                            : const Text('No profile picture uploaded')),
                    const SizedBox(height: 20),
                    Text('Your old name: $_currentName'),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'New name (optional)',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Upload Picture'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveChanges,
                      child: const Text('Save changes'),
                    ),
                  ],
                ),
              ),
    );
  }
}
