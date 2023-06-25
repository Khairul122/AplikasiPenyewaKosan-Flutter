import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PemesananPage extends StatefulWidget {
  const PemesananPage({Key? key}) : super(key: key);

  @override
  _PemesananPageState createState() => _PemesananPageState();
}

class _PemesananPageState extends State<PemesananPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  String? _selectedGender;
  String? _selectedRoom;

  final List<String> genders = ['Pria', 'Wanita'];
  final List<String> rooms = [
    'Kamar 1',
    'Kamar 2',
    'Kamar 3',
    'Kamar 4',
    'Kamar 5'
  ];

  void _simpanPemesanan() async {
    final User? user = _auth.currentUser;
    final String userId = user!.uid;

    final String nama = _namaController.text.trim();
    final String alamat = _alamatController.text.trim();
    final String telepon = _teleponController.text.trim();

    // Validasi input data
    if (nama.isEmpty ||
        alamat.isEmpty ||
        telepon.isEmpty ||
        _selectedGender == null ||
        _selectedRoom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mohon lengkapi semua data'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users') // Merujuk ke koleksi 'users'
          .doc(userId) // Merujuk ke dokumen dengan ID user
          .collection(
              'pemesanan') // Merujuk ke subkoleksi 'pemesanan' di dalam dokumen user
          .add({
        'nama': nama,
        'alamat': alamat,
        'telepon': telepon,
        'jenisKelamin': _selectedGender,
        'kamar': _selectedRoom,
      });

      // Menampilkan notifikasi pemesanan berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pemesanan berhasil disimpan'),
          backgroundColor: Colors.green,
        ),
      );

      // Mengosongkan field input setelah data tersimpan
      _namaController.clear();
      _alamatController.clear();
      _teleponController.clear();
      _selectedGender = null;
      _selectedRoom = null;
    } catch (e) {
      // Menampilkan pesan kesalahan jika terjadi error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Pemesanan Kamar Kos',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Data Pemesanan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: 'Nama',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _alamatController,
              decoration: InputDecoration(
                labelText: 'Alamat',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _teleponController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Telepon',
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(
                labelText: 'Jenis Kelamin',
                prefixIcon: Icon(Icons.person),
              ),
              items: genders.map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(
                    gender,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
            SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              value: _selectedRoom,
              decoration: InputDecoration(
                labelText: 'Kamar',
                prefixIcon: Icon(Icons.room),
              ),
              items: rooms.map((String room) {
                return DropdownMenuItem<String>(
                  value: room,
                  child: Text(
                    room,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedRoom = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _simpanPemesanan,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.green,
                ),
              ),
              child: Text(
                'Simpan Pemesanan',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
