import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intracake/components/section.dart';
import 'package:intracake/data/dummy.dart';
import 'package:intracake/screen/setting_screen.dart';
import 'package:intracake/screen/create_screen.dart';
import 'package:intracake/components/section_headlines.dart';
import 'package:intracake/screen/welcome_screen.dart'; // Pastikan welcome_screen sudah diimport

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userEmail;

  @override
  void initState() {
    super.initState();
    fetchUserEmail();
  }

  Future<void> fetchUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        userEmail = doc['email'] ?? 'Email tidak ditemukan';
      });
    }
  }

  Future<void> logoutWithConfirmation() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda ingin logout?'),
        actions: [
          TextButton(
            child: const Text('Tidak'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Ya'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sections = [
      Section(
        title: "Kue Tradisional Populer",
        subTitle: "Rekomendasi terbaik minggu ini",
        items: dummyCakes,
      ),
      Section(
        title: "Resep yang Telah Anda Buat!",
        subTitle: "Kumpulan kreasi terbaikmu",
        items: dummyCakes,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'setting') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              } else if (value == 'create_recipe') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateScreen()),
                );
              } else if (value == 'logout') {
                logoutWithConfirmation();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'setting',
                child: Text('Setting'),
              ),
              const PopupMenuItem<String>(
                value: 'create_recipe',
                child: Text('Isi Resep'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
            icon: const Icon(Icons.more_vert, color: Colors.pink),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              userEmail != null
                  ? 'Selamat Datang di Intracake, $userEmail'
                  : 'Selamat Datang di Intracake...',
              style: const TextStyle(
                fontFamily: 'Alata',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
              textAlign: TextAlign.left,
            ),
            if (userEmail != null) ...[
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 24),
            ...sections.map((section) => buildCakeSection(section)),
          ],
        ),
      ),
    );
  }
}
