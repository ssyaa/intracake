import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _titleController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _image;

  final ImagePicker _picker = ImagePicker();

  final cloudinary = Cloudinary.full(
    apiKey: '273748746699978',
    apiSecret: 'sqdwwnAck5v6Nn56tTi041A_Hsk',
    cloudName: 'dkxlgujvc',
  );

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImageToCloudinary() async {
    if (_image == null) return null;

    try {
      final response = await cloudinary.uploadResource(
        CloudinaryUploadResource(
          filePath: _image!.path,
          resourceType: CloudinaryResourceType.image,
          folder: 'intracake',
        ),
      );

      if (response.isSuccessful && response.secureUrl != null) {
        return response.secureUrl!;
      } else {
        final errorMessage = response.error ?? 'Terjadi kesalahan saat mengupload gambar';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mengupload gambar: $errorMessage')),
          );
        }
        return null;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengupload gambar: $e')),
        );
      }
      return null;
    }
  }


  Future<void> _submitRecipe() async {
    if (!_formKey.currentState!.validate()) return;
    if (_image == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan pilih gambar terlebih dahulu.')),
        );
      }
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;
    final title = _titleController.text.trim();
    final ingredients = _ingredientsController.text.trim();
    final steps = _stepsController.text.trim();

    try {
      final imageUrl = await _uploadImageToCloudinary();
      if (imageUrl == null) return;

      final cakeData = {
        'title': title,
        'ingredients': ingredients,
        'steps': steps,
        'imgurl': imageUrl, // << disimpan ke imgurl
        'createdBy': uid,
        'createdAt': Timestamp.now(),
      };

      final newCake = await FirebaseFirestore.instance.collection('cake').add(cakeData);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('cake')
          .doc(newCake.id)
          .set(cakeData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resep berhasil ditambahkan!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan resep: $e')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Resep'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Nama Kue'),
                validator: (value) => value == null || value.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(labelText: 'Bahan-bahan'),
                maxLines: 4,
                validator: (value) => value == null || value.isEmpty ? 'Bahan wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stepsController,
                decoration: const InputDecoration(labelText: 'Cara Pembuatan'),
                maxLines: 6,
                validator: (value) => value == null || value.isEmpty ? 'Langkah pembuatan wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickImage,
                child: _image == null
                    ? Container(
                  color: Colors.grey[200],
                  height: 150,
                  child: const Icon(Icons.add_a_photo, size: 50),
                )
                    : Image.file(_image!, height: 150, fit: BoxFit.cover),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitRecipe,
                child: const Text('Simpan Resep'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
