import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intracake/components/section.dart';
import 'package:intracake/data/dummy.dart';
import 'package:intracake/screen/setting_screen.dart';
import 'package:intracake/screen/create_screen.dart';
import 'package:intracake/components/section_headlines.dart';

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
            ],
            icon: const Icon(Icons.more_vert, color: Colors.pink),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [ Text(
              userEmail != null
                  ? 'Selamat Datang di Intracake, $userEmail'
                  : 'Selamat Datang di Intracake...',
                style: TextStyle(
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
