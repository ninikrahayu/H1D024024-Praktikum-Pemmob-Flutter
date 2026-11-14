
import 'package:flutter/material.dart';
import 'package:tokokita/ui/login_page.dart';
import 'package:tokokita/ui/registrasi_page.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/ui/produk_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Kita',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/registrasi': (context) => const RegistrasiPage(),
        '/produk': (context) => const ProdukPage(),
        '/produk/tambah': (context) => const ProdukForm(),
      },
    );
  }
}
