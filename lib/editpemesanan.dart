import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPemesananPage extends StatefulWidget {
  final String documentId;

  EditPemesananPage({required this.documentId});

  @override
  _EditPemesananPageState createState() => _EditPemesananPageState();
}

class _EditPemesananPageState extends State<EditPemesananPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _jenisKelaminController = TextEditingController();
  final TextEditingController _kamarController = TextEditingController();

  List<String> jenisKelaminOptions = ['Pria', 'Wanita'];
  List<String> kamarOptions = [
    'Kamar 1',
    'Kamar 2',
    'Kamar 3',
    'Kamar 4',
    'Kamar 5'
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('pemesanan')
              .doc(widget.documentId)
              .get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        _namaController.text = data?['nama'] ?? '';
        _alamatController.text = data?['alamat'] ?? '';
        _teleponController.text = data?['telepon'] ?? '';
        _jenisKelaminController.text = data?['jenisKelamin'] ?? '';
        _kamarController.text = data?['kamar'] ?? '';
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _updateData() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('pemesanan')
          .doc(widget.documentId)
          .update({
        'nama': _namaController.text,
        'alamat': _alamatController.text,
        'telepon': _teleponController.text,
        'jenisKelamin': _jenisKelaminController.text,
        'kamar': _kamarController.text,
      });

      // Show success notification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil disimpan')),
      );

      // Navigate back to LihatPemesananPage
      Navigator.pop(context);
    } catch (e) {
      // Handle error
    }
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItems(List<String> options) {
    return options.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Pemesanan'),
        backgroundColor: Colors.green, // Mengubah warna AppBar menjadi hijau
        iconTheme: IconThemeData(
          color: Colors.white, // Mengubah warna ikon AppBar menjadi putih
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: 'Nama',
                labelStyle: TextStyle(
                    color: Colors
                        .black), // Mengubah warna label input menjadi hijau
              ),
            ),
            TextField(
              controller: _alamatController,
              decoration: InputDecoration(
                labelText: 'Alamat',
                labelStyle: TextStyle(
                    color: Colors
                        .black), // Mengubah warna label input menjadi hijau
              ),
            ),
            TextField(
              controller: _teleponController,
              decoration: InputDecoration(
                labelText: 'Telepon',
                labelStyle: TextStyle(
                    color: Colors
                        .black), // Mengubah warna label input menjadi hijau
              ),
            ),
            DropdownButtonFormField<String>(
              value: _jenisKelaminController.text.isNotEmpty
                  ? _jenisKelaminController.text
                  : null,
              items: buildDropdownMenuItems(jenisKelaminOptions),
              onChanged: (newValue) {
                setState(() {
                  _jenisKelaminController.text = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Jenis Kelamin',
                labelStyle: TextStyle(
                    color: Colors
                        .black), // Mengubah warna label input menjadi hijau
              ),
            ),
            DropdownButtonFormField<String>(
              value: _kamarController.text.isNotEmpty
                  ? _kamarController.text
                  : null,
              items: buildDropdownMenuItems(kamarOptions),
              onChanged: (newValue) {
                setState(() {
                  _kamarController.text = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Kamar',
                labelStyle: TextStyle(
                    color: Colors
                        .black), // Mengubah warna label input menjadi hijau
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _updateData();
              },
              child: Text('Simpan'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Mengubah warna tombol menjadi hijau
              ),
            ),
          ],
        ),
      ),
    );
  }
}
