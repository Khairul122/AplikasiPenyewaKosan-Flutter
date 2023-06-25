import 'package:aplikasi_penyewa/lihatpemesanan.dart';
import 'package:aplikasi_penyewa/pemesananpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  final User? user;

  const HomePage({required this.user});

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String username = user?.email?.split('@')[0] ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Aplikasi Kos Yanti'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32.0),
            Text(
              "Selamat datang",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              username,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 32.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildMenuItem(
                    Icons.home, // Ubah ikon menjadi ikon sepeda motor
                    'Pemesanan',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PemesananPage()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    Icons.list_alt, // Ubah ikon menjadi ikon daftar
                    'Lihat Pemesanan',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LihatPemesananPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48.0,
              color: Colors.green,
            ),
            SizedBox(height: 8.0),
            Text(
              label,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
