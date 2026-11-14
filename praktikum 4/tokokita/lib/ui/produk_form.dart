
import 'package:flutter/material.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/services/api_service.dart';

class ProdukForm extends StatefulWidget {
  final Produk? produk;

  const ProdukForm({super.key, this.produk});

  @override
  State<ProdukForm> createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();

  String judul = "Tambah Produk";
  String tombolSubmit = "Simpan";

  final _kodeProdukController = TextEditingController();
  final _namaProdukController = TextEditingController();
  final _hargaProdukController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  void isUpdate() {
    if (widget.produk != null) {
      judul = "UBAH PRODUK";
      tombolSubmit = "UBAH";
      // Judul dan tombol mode ubah memakai huruf kapital sesuai tampilan.

      _kodeProdukController.text =
          widget.produk!.kodeProduk ?? "";

      _namaProdukController.text =
          widget.produk!.namaProduk ?? "";

      _hargaProdukController.text =
          widget.produk!.hargaProduk?.toString() ?? "";
    }
  }

  @override
  void dispose() {
    _kodeProdukController.dispose();
    _namaProdukController.dispose();
    _hargaProdukController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text(judul),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _kodeProdukTextField(),
              _namaProdukTextField(),
              _hargaProdukTextField(),
              const SizedBox(height: 8),
              _buttonSubmit(),
            ],
          ),
        ),
      ),
    );
  }

  // Input Kode Produk
  Widget _kodeProdukTextField() {
    return TextFormField(
      controller: _kodeProdukController,
      decoration: const InputDecoration(
        labelText: "Kode Produk",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Kode Produk harus diisi";
        }
        return null;
      },
    );
  }

  // Input Nama Produk
  Widget _namaProdukTextField() {
    return TextFormField(
      controller: _namaProdukController,
      decoration: const InputDecoration(
        labelText: "Nama Produk",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Nama Produk harus diisi";
        }
        return null;
      },
    );
  }

  // Input Harga Produk
  Widget _hargaProdukTextField() {
    return TextFormField(
      controller: _hargaProdukController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: "Harga",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Harga harus diisi";
        }

        if (int.tryParse(value) == null) {
          return "Harga harus berupa angka";
        }

        return null;
      },
    );
  }

  // Tombol Simpan / Ubah
  Widget _buttonSubmit() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black87,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
      ),
      onPressed: _sedangProses ? null : _simpan,
      child: Text(tombolSubmit),
    );
  }

  bool _sedangProses = false;

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    setState(() => _sedangProses = true);

    final produk = Produk(
      id: widget.produk?.id,
      kodeProduk: _kodeProdukController.text.trim(),
      namaProduk: _namaProdukController.text.trim(),
      hargaProduk: int.parse(_hargaProdukController.text),
    );

    try {
      if (widget.produk == null) {
        await ApiService.tambahProduk(produk);
      } else {
        await ApiService.ubahProduk(produk);
      }
      navigator.pop(true);
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
}
