import 'package:flutter/material.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/services/api_service.dart';
import 'package:tokokita/ui/produk_detail.dart';
import 'package:tokokita/ui/produk_form.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  late Future<List<Produk>> daftarProduk;

  @override
  void initState() {
    super.initState();
    refreshProduk();
  }

  // Mengambil ulang data produk dari API
  void refreshProduk() {
    setState(() {
      daftarProduk = ApiService.getProduk();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text('List Produk'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProdukForm(),
                  ),
                );

                if (mounted) {
                  refreshProduk();
                }
              },
            ),
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),

      body: FutureBuilder<List<Produk>>(
        future: daftarProduk,
        builder: (context, snapshot) {
          // Sedang mengambil data
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Gagal mengambil data
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Gagal mengambil data produk\n'
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: refreshProduk,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final produk = snapshot.data ?? [];

          // Database masih kosong
          if (produk.isEmpty) {
            return const Center(
              child: Text('Belum ada produk'),
            );
          }

          // Menampilkan produk dari database
          return RefreshIndicator(
            onRefresh: () async {
              refreshProduk();
              await daftarProduk;
            },
            child: ListView.builder(
              itemCount: produk.length,
              itemBuilder: (context, index) {
                return ItemProduk(
                  produk: produk[index],
                  onRefresh: refreshProduk,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ItemProduk extends StatelessWidget {
  final Produk produk;
  final VoidCallback onRefresh;

  const ItemProduk({
    super.key,
    required this.produk,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProdukDetail(
              produk: produk,
            ),
          ),
        );

        onRefresh();
      },

      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        margin: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 4,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: ListTile(
          title: Text(produk.namaProduk ?? ''),
          subtitle: Text(
            produk.hargaProduk?.toString() ?? '0',
          ),
        ),
      ),
    );
  }
}
