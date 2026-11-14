
import 'package:flutter/material.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/services/api_service.dart';
import 'package:tokokita/ui/produk_form.dart';

class ProdukDetail extends StatefulWidget {
  final Produk produk;

  const ProdukDetail({
    super.key,
    required this.produk,
  });

  @override
  State<ProdukDetail> createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Kode : ${widget.produk.kodeProduk}",
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              "Nama : ${widget.produk.namaProduk}",
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "Harga : Rp. ${widget.produk.hargaProduk}",
              style: const TextStyle(fontSize: 18),
            ),
            _tombolHapusEdit(),
          ],
        ),
      ),
    );
  }

  // Tombol Edit dan Delete
  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tombol Edit
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.black87,
            minimumSize: const Size(98, 36),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
          ),
          onPressed: () async {
            final berhasil = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (context) => ProdukForm(
                  produk: widget.produk,
                ),
              ),
            );

            // Setelah diubah, kembali ke daftar agar data dimuat ulang.
            if (berhasil == true && mounted) {
              Navigator.pop(context, true);
            }
          },
          child: const Text("EDIT"),
        ),

        // Tombol Delete
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.black87,
            minimumSize: const Size(98, 36),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
          ),
          onPressed: confirmHapus,
          child: const Text("DELETE"),
        ),
      ],
    );
  }

  // Dialog Konfirmasi Hapus
  void confirmHapus() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
            "Yakin ingin menghapus data ini?",
          ),
          actions: [
            // Tombol Ya
            OutlinedButton(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(this.context);
                final navigator = Navigator.of(this.context);
                Navigator.pop(context);

                try {
                  await ApiService.hapusProduk(widget.produk.id!);
                  navigator.pop(true);
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString().replaceFirst('Exception: ', ''),
                      ),
                    ),
                  );
                }
              },
              child: const Text("Ya"),
            ),

            // Tombol Batal
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Batal"),
            ),
          ],
        );
      },
    );
  }
}
