
import 'package:flutter/material.dart';
import 'package:tokokita/services/api_service.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({super.key});

  @override
  State<RegistrasiPage> createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _konfirmasiController.dispose();
    super.dispose();
  }

  bool _sedangProses = false;

  Future<void> _registrasi() async {
    if (!_formKey.currentState!.validate()) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    setState(() => _sedangProses = true);

    try {
      await ApiService.registrasi(
        nama: _namaController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Registrasi berhasil, silakan login'),
        ),
      );
      navigator.pop();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
      if (mounted) setState(() => _sedangProses = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Nama wajib diisi'
                        : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Email wajib diisi'
                        : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) =>
                    value == null || value.length < 6
                        ? 'Password minimal 6 karakter'
                        : null,
              ),
              TextFormField(
                controller: _konfirmasiController,
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi Password',
                ),
                obscureText: true,
                validator: (value) =>
                    value != _passwordController.text
                        ? 'Password tidak sama'
                        : null,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _sedangProses ? null : _registrasi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black87,
                  elevation: 2,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
                child: const Text('Registrasi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
