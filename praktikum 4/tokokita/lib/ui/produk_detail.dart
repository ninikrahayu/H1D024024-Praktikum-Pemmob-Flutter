import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_form.dart';

class ProdukDetail extends StatefulWidget {
  Produk? produk;

  ProdukDetail({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk')),
      body: Center(
        child: Column(
          children: [
            Text(
              "Kode : ${widget.produk!.kodeProduk}",
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(
              "Nama : ${widget.produk!.namaProduk}",
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              "Harga : Rp. ${widget.produk!.hargaProduk.toString()}",
              style: const TextStyle(fontSize: 18.0),
            ),
            _tombolHapusEdit(),
          ],
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tombol Edit
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.green.shade800),
          child: const Text("EDIT"),
          onPressed: _isDeleting
              ? null
              : () async {
                  final updated = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProdukForm(produk: widget.produk!),
                    ),
                  );
                  if (mounted && updated == true) {
                    Navigator.pop(context, true);
                  }
                },
        ),
        const SizedBox(width: 8),

        // Tombol Hapus
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red.shade800),
          child: const Text("DELETE"),
          onPressed: _isDeleting ? null : confirmHapus,
        ),
      ],
    );
  }

  Future<void> confirmHapus() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Hapus produk?"),
        content: Text('Produk "${widget.produk!.namaProduk}" akan dihapus.'),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Batal"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade800),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;

    setState(() => _isDeleting = true);
    try {
      final deleted = await ProdukBloc.deleteProduk(id: widget.produk!.id);
      if (!mounted) return;
      if (deleted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Produk berhasil dihapus.")),
        );
        Navigator.pop(context, true);
        return;
      }
    } catch (error) {
      debugPrint('Gagal menghapus produk: $error');
    }
    if (!mounted) return;
    setState(() => _isDeleting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Produk gagal dihapus. Coba lagi.")),
    );
  }
}
