import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _usernameController = TextEditingController();
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil')),
        body: const Center(child: Text('Kamu belum login')),
      );
    }

    final userDoc = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userDoc.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Data pengguna tidak ditemukan'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          _usernameController.text = userData['username'] ?? '';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Username',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _usernameController,
                  enabled: _isEditing,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan username',
                  ),
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () async {
                    if (_isEditing) {
                      // Simpan perubahan
                      await userDoc.update({
                        'username': _usernameController.text.trim(),
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Username berhasil diperbarui!')),
                      );
                    }

                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                  child: Text(_isEditing ? 'Simpan' : 'Edit Username'),
                ),

                const SizedBox(height: 24),
                const Text(
                  'Email',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(currentUser.email ?? 'Tidak ada email'),
              ],
            ),
          );
        },
      ),
    );
  }
}
