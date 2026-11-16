# myportofolio_mobile

Aplikasi portofolio pribadi berbasis mobile menggunakan Flutter. Proyek ini dikembangkan sebagai bagian dari penugasan mata kuliah Pemrograman Berbasis Platform (PBP) Fakultas Ilmu Komputer Universitas Indonesia.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

### Tugas 7

1. **Jelaskan apa yang dimaksud dengan widget tree pada Flutter dan bagaimana hubungan induk-anak (parent-child) bekerja antar-widget!**
   * *Widget tree* adalah struktur hierarki pohon yang merepresentasikan bagaimana berbagai widget disusun dan diorganisasikan untuk membentuk antarmuka (UI) aplikasi Flutter.
   * Hubungan induk-anak (*parent-child*) bekerja dengan cara widget induk bertindak sebagai kontainer atau pengatur tata letak yang membungkus satu atau beberapa widget anak di dalamnya. Widget anak mewarisi properti, batasan ukuran (*constraints*), dan konteks dari widget induknya, serta dapat meneruskan aksi atau data kembali ke atas melalui *callback*.

2. **Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya masing-masing!**
   * `MaterialApp`: Widget akar (*root*) yang mengonfigurasi aplikasi dengan gaya desain Material, termasuk tema warna, judul, dan rute navigasi utama.
   * `Scaffold`: Widget kerangka dasar visual yang menyediakan struktur tata letak standar Material Design seperti `AppBar` dan `body`.
   * `AppBar`: Widget bilah aplikasi di bagian atas layar untuk menampilkan judul halaman.
   * `Padding`: Widget untuk memberikan ruang kosong (*padding*) di sekeliling widget anaknya.
   * `Column`: Widget tata letak linier yang menyusun widget anak-anaknya secara vertikal (ke bawah).
   * `Row`: Widget tata letak linier yang menyusun widget anak-anaknya secara horizontal (ke samping).
   * `Card`: Widget panel bergaya material dengan sudut melengkung dan efek bayangan (*elevation*) untuk mengelompokkan informasi.
   * `GridView.count`: Widget untuk menampilkan daftar anak dalam bentuk grid (kotak-kotak) dengan jumlah kolom tetap.
   * `Text`: Widget untuk menampilkan teks atau string di layar dengan gaya tertentu.
   * `Icon`: Widget untuk menampilkan ikon grafis berbasis pustaka Material Icons.
   * `Material`: Widget yang mendasari desain material untuk memberikan efek visual seperti warna latar dan bentuk sudut melengkung (*border radius*).
   * `InkWell`: Widget transparan yang mendeteksi gestur sentuhan (*tap*) dan memberikan efek visual percikan air (*ripple effect*) saat ditekan.
   * `Container`: Widget multiguna yang menggabungkan dekorasi, padding, margin, dan pengaturan ukuran untuk widget anaknya.
   * `Center`: Widget yang memposisikan widget anaknya tepat di tengah area yang tersedia.
   * `SnackBar`: Widget penampil pesan singkat sementara di bagian bawah layar sebagai respons interaksi pengguna.

3. **Apa fungsi dari widget MaterialApp? Jelaskan mengapa widget ini umumnya digunakan sebagai root widget pada aplikasi Flutter!**
   * Widget `MaterialApp` berfungsi sebagai konfigurasi dasar yang menyatukan berbagai layanan penting dalam ekosistem Material Design, seperti manajemen navigasi (*navigator*), pengaturan tema global (*theme*), orientasi, dan lokalisasi aplikasi.
   * Widget ini umumnya digunakan sebagai *root widget* karena bertindak sebagai fondasi teratas yang membungkus seluruh hierarki aplikasi, memastikan semua komponen di bawahnya dapat mengakses gaya desain, tema warna, dan utilitas sistem Material secara konsisten.

4. **Jelaskan perbedaan antara StatelessWidget dan StatefulWidget! Kapan kita sebaiknya memilih StatelessWidget dan kapan harus menggunakan StatefulWidget?**
   * `StatelessWidget` adalah widget yang bersifat statis; keadaannya (*state*) tidak dapat berubah sepanjang siklus hidupnya setelah dirender karena tidak memiliki data internal yang dapat dimodifikasi.
   * `StatefulWidget` adalah widget yang bersifat dinamis; ia dapat melacak perubahan data (*state*) dan memperbarui tampilan antarmuka secara langsung melalui fungsi `setState()` ketika terjadi interaksi pengguna atau pembaruan data.
   * Kita sebaiknya memilih `StatelessWidget` untuk komponen antarmuka yang bersifat statis atau hanya menampilkan informasi tetap (seperti kartu profil atau teks statis). Sebaliknya, kita memilih `StatefulWidget` ketika komponen memerlukan perubahan tampilan secara interaktif (seperti formulir input, tombol counter, atau data yang diambil secara dinamis dari API).

5. **Apa itu BuildContext dan mengapa penting di Flutter? Bagaimana penggunaannya di dalam metode build?**
   * `BuildContext` adalah sebuah objek yang mereferensikan lokasi sebuah widget di dalam struktur *widget tree*.
   * Objek ini sangat penting karena bertindak sebagai penghubung bagi widget untuk mencari informasi tentang lingkungan sekitarnya, mengakses tema, ukuran layar, media query, serta mencari widget leluhur (*ancestor*) seperti `Scaffold` atau `Navigator`.
   * Di dalam metode `build(BuildContext context)`, parameter `context` diteruskan secara otomatis oleh framework Flutter untuk memberi tahu kerangka kerja di bagian mana dari pohon widget komponen tersebut sedang dibangun, serta digunakan saat kita ingin memanggil fungsi seperti `ScaffoldMessenger.of(context)` atau `Navigator.of(context)`.

6. **Jelaskan konsep hot reload di Flutter dan apa perbedaannya dengan hot restart! Kapan kita tidak bisa hanya mengandalkan hot reload dan harus melakukan hot restart atau full restart?**
   * *Hot reload* bekerja dengan cara memasukkan file kode yang telah diubah ke dalam *Dart Virtual Machine* (VM) yang sedang berjalan tanpa kehilangan status aplikasi saat ini (*state*), sehingga perubahan UI dapat terlihat secara instan dalam hitungan detik.
   * *Hot restart*, di sisi lain, memuat ulang seluruh aplikasi dari awal dan mereset status aplikasi kembali ke kondisi awal (*state* hilang).
   * Kita tidak bisa mengandalkan *hot reload* dan wajib melakukan *hot restart* (atau *full restart*) ketika kita melakukan perubahan pada struktur inisialisasi global seperti fungsi `main()`, mengubah variabel global/statis, memodifikasi struktur kelas, mengubah aset atau dependensi (`pubspec.yaml`), atau mengubah logika pengendali *state* inisial yang hanya dijalankan sekali saat aplikasi pertama kali dimuat.

---

### AI Disclosure & Dokumentasi Proyek

#### 1. Transparansi Penggunaan AI & Tools
* **Tools yang Digunakan**: Gemini AI (sebagai kolaborator AI pribadi) dan Visual Studio Code (sebagai IDE utama).
* **Bagian yang Dibantu oleh AI**: 
  * Perancangan struktur modular kode Flutter (pemisahan berkas `menu.dart` dari `main.dart`).
  * Penyusunan logika model data `ItemHomepage` untuk penerapan kustomisasi warna kartu tombol secara dinamis tanpa pengulangan kode.
  * Pembuatan draf jawaban untuk pertanyaan reflektif konseptual (seperti pemahaman *widget tree*, perbedaan *StatelessWidget* dan *StatefulWidget*, serta analisis *BuildContext*).
* **Strategi Prompting**: Menggunakan pendekatan interaktif dan kontekstual berbasis studi kasus praktis, di mana AI diarahkan secara spesifik untuk mematuhi panduan modul praktikum PBP Universitas Indonesia.

#### 2. Analisis Kritis & Perbaikan Manual
Meskipun AI membantu mempercepat penulisan draf dan struktur dasar kode serta dokumentasi, beberapa aspek memerlukan penyesuaian dan verifikasi manual secara cermat:
* **Penyesuaian Data Identitas**: Draf awal dari AI menggunakan data tiruan (seperti contoh *Burhan*), yang kemudian secara manual diganti dan disesuaikan sepenuhnya dengan data identitas pribadi pemilik portofolio yang akurat (NPM, Nama Lengkap, dan Kelas PBP).
* **Validasi Sintaks & Analisis Kode**: Kode yang dihasilkan diuji secara langsung melalui terminal menggunakan perintah `flutter analyze` untuk memastikan kepatuhan terhadap standar linter Flutter hingga menghasilkan keluaran bersih tanpa peringatan (*No issues found!*).
* **Pengujian Interaksi UI**: Memastikan bahwa fungsi `SnackBar` dan pewarnaan latar tombol merespons gestur sentuhan dengan mulus di lingkungan peramban Google Chrome tanpa adanya galat *runtime*.