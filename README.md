# Pemrograman Mobile
## Pertemuan 1

### Identitas

**Nama:** Ninik Rahayu  
**NIM:** H1D024024  
**Shift Awal:** H  
**Shift Akhir:** F  

### Screenshoot
<img width="874" height="321" alt="image" src="https://github.com/user-attachments/assets/d4254806-021e-46a2-a17c-080682a2b604" />

### Penjelasan Singkat
Program menggunakan class Queue<T> untuk menyimpan antrean dengan prinsip FIFO (First In, First Out): data yang pertama masuk akan keluar lebih dahulu.

- _items: List untuk menyimpan data antrean.
- enqueue(data): menambahkan data ke bagian belakang antrean.
- dequeue(): mengambil sekaligus menghapus data paling depan menggunakan removeAt(0). Jika antrean kosong, method melempar StateError.
- toString(): menampilkan isi antrean saat dipanggil melalui print().

Pada main(), program memasukkan 10, 20, dan 30, lalu mengeluarkan 10. Setelah 40 ditambahkan, isi antrean menjadi [20, 30, 40]. Data kemudian dikeluarkan berurutan hingga kosong. Pemanggilan dequeue() terakhir ditangani oleh try-catch sehingga pesan antrean kosong ditampilkan tanpa menghentikan program secara paksa.

## Pertemuan 2
### Screenshoot
<img width="300" alt="image" src="https://github.com/user-attachments/assets/6659c875-510a-4e8d-bda2-d24a682e037c" />
<img width="300" alt="image" src="https://github.com/user-attachments/assets/5731c7d8-110d-4653-9c38-b5242622077c" />
