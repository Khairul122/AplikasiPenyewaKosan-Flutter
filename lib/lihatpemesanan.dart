import 'package:aplikasi_penyewa/editpemesanan.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(
    home: LihatPemesananPage(),
    theme: ThemeData(
      primaryColor: Colors.green, // Mengubah warna utama menjadi hijau
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        color: Colors.white, // Mengubah warna AppBar menjadi putih
        iconTheme: IconThemeData(
          color: Colors.green, // Mengubah warna ikon AppBar menjadi hijau
        ),
      ),
    ),
  ));
}

class LihatPemesananPage extends StatefulWidget {
  @override
  _LihatPemesananPageState createState() => _LihatPemesananPageState();
}

class _LihatPemesananPageState extends State<LihatPemesananPage> {
  User? user;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _pemesananStream;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    user = await FirebaseAuth.instance.currentUser;
    setState(() {
      _pemesananStream = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('pemesanan')
          .snapshots();
    });
  }

  Future<void> hapusData(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('pemesanan')
          .doc(documentId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat menghapus data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Lihat Pemesanan'),
        backgroundColor: Colors.white, // Mengubah warna AppBar menjadi putih
        iconTheme: IconThemeData(
          color: Colors.green, // Mengubah warna ikon AppBar menjadi hijau
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _pemesananStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data?.docs.isEmpty ?? true) {
            return Center(
              child: Text('Tidak ada data pemesanan'),
            );
          }

          return ListView(
            padding: EdgeInsets.all(16),
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data();
              final nama = data['nama'];
              final alamat = data['alamat'];
              final telepon = data['telepon'];
              final jenisKelamin = data['jenisKelamin'];
              final kamar = data['kamar'];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPemesananPage(
                        documentId: doc.id,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nama: $nama',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Alamat: $alamat'),
                        Text('Telepon: $telepon'),
                        Text('Jenis Kelamin: $jenisKelamin'),
                        SizedBox(height: 16),
                        Text(
                          'Kamar: $kamar',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditPemesananPage(
                                      documentId: doc.id,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    size: 24,
                                    color: Colors.green,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.green,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                            InkWell(
                              onTap: () {
                                hapusData(doc.id);
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'Hapus',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.green,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.delete,
                                    size: 24,
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
