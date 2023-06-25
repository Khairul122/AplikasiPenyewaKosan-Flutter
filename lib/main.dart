import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'splashscreen.dart';
import 'loginpage.dart';
import 'registrasipage.dart';
import 'pemesananpage.dart';
import 'lihatpemesanan.dart';
import 'homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreenPage(),
        '/login': (context) => LoginPage(),
        '/registrasi': (context) => RegistrasiPage(),
        '/pemesanan': (context) => PemesananPage(),
        '/lihatpemesanan': (context) => LihatPemesananPage(),
        '/home': (context) => FutureBuilder<User?>(
              future: FirebaseAuth.instance.authStateChanges().first,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SplashScreenPage();
                }
                if (snapshot.hasData) {
                  return HomePage(user: snapshot.data);
                }
                return LoginPage();
              },
            ),
      },
    );
  }
}
