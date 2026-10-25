// Queue menggunakan prinsip FIFO (First In, First Out):
// data yang pertama masuk akan menjadi data yang pertama keluar.
class Queue<T> {
  final List<T> _items = [];

  // Menambahkan data ke bagian belakang antrean.
  void enqueue(T data) {
    _items.add(data);
  }

  // Mengambil sekaligus menghapus data dari bagian depan antrean.
  T dequeue() {
    if (_items.isEmpty) {
      throw StateError('Antrean kosong, tidak ada data yang dapat dikeluarkan.');
    }
    return _items.removeAt(0);
  }

  @override
  String toString() => _items.toString();
}

void main() {
  final antrean = Queue<int>();

  print('Implementasi Queue (FIFO)');
  print('Antrean awal: $antrean');

  for (final data in [10, 20, 30]) {
    antrean.enqueue(data);
    print('enqueue($data) -> $antrean');
  }

  print('dequeue() -> ${antrean.dequeue()}');
  print('Sisa antrean: $antrean');

  antrean.enqueue(40);
  print('enqueue(40) -> $antrean');

  for (var i = 0; i < 3; i++) {
    print('dequeue() -> ${antrean.dequeue()}');
    print('Sisa antrean: $antrean');
  }

  // Menunjukkan penanganan dequeue ketika antrean sudah kosong.
  try {
    antrean.dequeue();
  } on StateError catch (error) {
    print('dequeue() -> ${error.message}');
  }
}
