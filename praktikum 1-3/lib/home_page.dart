
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sidemenu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? namauser;

  // Mengambil username dari local storage
  Future<void> _loadUsername() async {
    // Inisialisasi SharedPreferences
    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    // Ambil username yang sudah tersimpan
    String? username = prefs.getString('username');

    // Menampilkan username ke UI
    if (!mounted) return;

    setState(() {
      namauser = username;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Text('Ini adalah halaman User ${namauser ?? ''}'),
      ),
      drawer: const Sidemenu(),
    );
  }
}
