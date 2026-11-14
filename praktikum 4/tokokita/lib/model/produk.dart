
class Produk {
  int? id;
  String? kodeProduk;
  String? namaProduk;
  int? hargaProduk;

  Produk({
    this.id,
    this.kodeProduk,
    this.namaProduk,
    this.hargaProduk,
  });

  factory Produk.fromJson(Map<String, dynamic> obj) {
    return Produk(
      id: _keInt(obj['id']),
      kodeProduk: obj['kode_produk']?.toString(),
      namaProduk: obj['nama_produk']?.toString(),
      hargaProduk: _keInt(obj['harga']),
    );
  }

  // API bisa mengirim angka sebagai String ("5000000" atau "5000000.00").
  static int? _keInt(dynamic nilai) {
    if (nilai == null) return null;
    if (nilai is int) return nilai;
    if (nilai is num) return nilai.toInt();
    return num.tryParse(nilai.toString())?.toInt();
  }
}
