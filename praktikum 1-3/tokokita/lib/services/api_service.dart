import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tokokita/model/login.dart';
import 'package:tokokita/model/produk.dart';

class ApiService {
  // HP fisik: pakai IP Wi-Fi laptop (HP & laptop harus satu jaringan).
  // Port 8080 dipakai Oracle XE, jadi API dijalankan di port 8081.
  static const String baseUrl = 'http://192.168.1.14:8081';

  // Mengambil daftar produk dari CodeIgniter
  static Future<List<Produk>> getProduk() async {
    final response = await http.get(
      Uri.parse('$baseUrl/produk'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['status'] != true) {
        throw Exception('Gagal mengambil produk');
      }

      final List<dynamic> data = json['data'];
      return data.map((item) => Produk.fromJson(item)).toList();
    }

    throw Exception(
      'Gagal mengambil produk: ${response.statusCode}',
    );
  }

  static const Map<String, String> _jsonHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  // Mengambil pesan error dari respon API
  static String _pesanError(http.Response response) {
    try {
      final data = jsonDecode(response.body)['data'];
      if (data is Map) return data.values.join(', ');
      if (data != null) return data.toString();
    } catch (_) {}
    return 'Kesalahan ${response.statusCode}';
  }

  static Map<String, dynamic> _body(Produk produk) => {
        'kode_produk': produk.kodeProduk,
        'nama_produk': produk.namaProduk,
        'harga': produk.hargaProduk,
      };

  // Registrasi akun baru
  static Future<void> registrasi({
    required String nama,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/registrasi'),
      headers: _jsonHeaders,
      body: jsonEncode({
        'nama': nama,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(_pesanError(response));
    }
  }

  // Login, mengembalikan token dan data user
  static Future<Login> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: _jsonHeaders,
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw Exception(_pesanError(response));
    }

    return Login.fromJson(jsonDecode(response.body));
  }

  // Menambah produk baru
  static Future<void> tambahProduk(Produk produk) async {
    final response = await http.post(
      Uri.parse('$baseUrl/produk'),
      headers: _jsonHeaders,
      body: jsonEncode(_body(produk)),
    );

    if (response.statusCode != 201) {
      throw Exception(_pesanError(response));
    }
  }

  // Mengubah produk yang sudah ada
  static Future<void> ubahProduk(Produk produk) async {
    final response = await http.put(
      Uri.parse('$baseUrl/produk/${produk.id}'),
      headers: _jsonHeaders,
      body: jsonEncode(_body(produk)),
    );

    if (response.statusCode != 200) {
      throw Exception(_pesanError(response));
    }
  }

  // Menghapus produk
  static Future<void> hapusProduk(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/produk/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception(_pesanError(response));
    }
  }
}
