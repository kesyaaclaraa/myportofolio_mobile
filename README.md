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

### Tutorial 09 — Navigation, Layouts, Forms, and Input Elements

Implementasi mengikuti `tutorial-9 (1).pdf` (27 halaman) dan melanjutkan proyek utama di direktori ini. Identitas Kesya Clara Dania, NPM 2506656892, kelas PBP C, serta warna tombol dari Tugas 7 dipertahankan.

#### Analisis dan pemetaan persyaratan

| Bagian PDF | Implementasi |
| --- | --- |
| Navigasi, hlm. 2–4 | `Navigator.push()` pada kartu Tambah Proyek; `Navigator.pushReplacement()` pada kedua tujuan drawer; `Navigator.pop()` untuk menutup drawer dan dialog. Back sistem dari form yang dibuka melalui kartu kembali ke menu. |
| Layout, hlm. 4–8 | Menu menggunakan Row, Expanded, Column, Padding, SizedBox, dan GridView; form dan dialog menggunakan SingleChildScrollView; drawer menggunakan ListView. Contoh Stack dan daftar proyek pada bagian teori menjelaskan alternatif layout, bukan halaman tambahan yang diwajibkan. |
| Paket Material, hlm. 9 | Seluruh file Dart pada `lib/` dan `test/` memakai `package:material_ui/material_ui.dart`. Dependensi `material_ui` sudah ditambahkan ke pubspec sebelum pengerjaan tutorial ini. |
| Drawer, hlm. 9–13 | `LeftDrawer` memiliki header My Portfolio, deskripsi, Home, dan Add Project. Drawer terpasang pada Scaffold menu dan form dengan ikon putih pada AppBar. |
| Form, hlm. 13–21 | `ProjectFormPage` berupa StatefulWidget; `Form` memakai `GlobalKey<FormState>` dan konten dapat digulir. Lima isian: nama, deskripsi, kategori, teknologi, dan tautan. |
| Validasi, hlm. 16–19 | Nama dan deskripsi wajib diisi; input yang hanya berisi spasi ditolak. Deskripsi menyediakan lima baris. Teknologi dan tautan boleh kosong sesuai contoh tutorial. |
| Kategori, hlm. 17–18 | Dropdown memakai `initialValue`, default Web Development; pilihan lainnya Mobile Development, Machine Learning, Data Science, dan Other. |
| Simpan dan dialog, hlm. 19–24 | Save menjalankan validasi sebelum menampilkan AlertDialog berjudul “Proyek berhasil ditambahkan!”. Dialog menampilkan kelima nilai dan kontennya dapat digulir. OK menutup dialog serta mengosongkan input dan state, termasuk mengembalikan kategori ke Web Development. |
| Tombol menu, hlm. 24–25 | Ketiga tombol tetap menampilkan SnackBar. Tambah Proyek juga membuka form melalui MaterialPageRoute dan `push()`. |
| Refactoring, hlm. 25–26 | Halaman berada di `screens/`; ItemCard dipindahkan ke `widgets/project_card.dart`; seluruh import terkait diperbarui. Tidak ada komentar latihan yang belum dilengkapi pada kode aplikasi. |
| Pengumpulan, hlm. 27 | Memerlukan commit yang di-push ke repositori GitHub publik dan tautan commit tersebut dikirim melalui SCELE. Tautan commit hasil akhir perlu dikirim oleh pemilik proyek melalui SCELE. |

Contoh PDF pada halaman 12 memiliki penempatan `drawer` dan tanda baca yang tidak lengkap. Implementasi menempatkan `drawer` pada `Scaffold`, sesuai penjelasan tutorial dan API widget. Nilai awal dropdown dibuat tetap agar reset benar-benar kembali ke kategori default; variabel state juga dihapus agar pengiriman kedua tidak menampilkan data lama.

```text
lib/
├── main.dart
├── screens/
│   ├── menu.dart
│   └── project_form.dart
└── widgets/
    ├── left_drawer.dart
    └── project_card.dart
```

#### Menjalankan dan memeriksa aplikasi

Jalankan perintah dari root proyek ini, bukan subfolder duplikat `myportofolio_mobile/`:

```sh
flutter pub get
flutter analyze --no-pub
flutter test --no-pub
flutter run
```

Pengujian widget pada `test/widget_test.dart` mencakup identitas dan SnackBar, navigasi push dan Back sistem, penggantian route lewat drawer pada kedua arah, penolakan isian kosong/spasi, lima pilihan kategori, isi dialog, pengiriman ulang setelah reset, field opsional, serta layar 320 × 568 tanpa overflow.

Untuk pemeriksaan manual, buka Tambah Proyek dari kartu, isi kelima field, tekan Save, periksa dialog, lalu tekan OK. Pastikan input kosong dan kategori kembali ke Web Development. Gunakan Back sistem untuk kembali ke menu. Coba juga Home dan Add Project melalui drawer; perpindahan ini mengganti route aktif.

Data proyek pada tutorial ini hanya ditampilkan di dialog, belum disimpan ke database atau dikirim ke REST API. Integrasi backend dan form bagian portofolio lain yang disebut sebagai Individual Assignment 8 berada di luar implementasi Tutorial 09.

#### Pengumpulan sesuai PDF

- Tenggat Tutorial 09: **Rabu, 18 November 2026 pukul 23.59 WIB**.
- Repositori tujuan yang terkonfigurasi: `https://github.com/kesyaaclaraa/myportofolio_mobile`.
- Tinjau perubahan, buat commit hasil akhir, kemudian push sebelum tenggat.
- Pastikan repositori bersifat publik.
- Salin tautan **commit hasil akhir** berbentuk `https://github.com/kesyaaclaraa/myportofolio_mobile/commit/<hash-commit>` ke slot submisi SCELE; tautan repositori saja tidak memenuhi ketentuan PDF.
- Tenggat Individual Assignment 8 yang disebut PDF: Senin, 23 November 2026 pukul 23.59 WIB. Tutorial 09 menjadi prasyarat penilaiannya.

---

### Tugas 8

1. **Perbedaan navigasi dan penggunaannya.** `Navigator.push()` menambahkan route di atas stack sehingga route sebelumnya dapat dibuka kembali dengan Back. `Navigator.pushReplacement()` mengganti route aktif; route yang diganti tidak menjadi tujuan Back. `Navigator.pop()` mengeluarkan route teratas, misalnya menutup dialog atau drawer. Kartu **Tambah Edukasi** menggunakan `push()` dengan `MaterialPageRoute`, sehingga Back perangkat kembali ke menu. Opsi **Home** menutup drawer memakai `pop()`, lalu mengganti halaman aktif dengan `MyHomePage` melalui `pushReplacement()`. Home juga dapat digunakan ketika menjalankan aplikasi di Chrome.

2. **Struktur halaman dan tema.** `Scaffold` menyediakan kerangka halaman, `AppBar` menampilkan judul, dan `Drawer` menyediakan tujuan navigasi bersama. Menu, form proyek, dan form edukasi memakai komponen `LeftDrawer` yang sama, dengan opsi Home, Add Project, dan Tambah Edukasi. AppBar menu dan edukasi mengambil `Theme.of(context).colorScheme.primary` dari tema indigo di `main.dart`; tombol Simpan edukasi menggunakan warna tema yang sama dan teks putih.

3. **Alasan pemilihan layout.** Form edukasi menggunakan `Column` agar kolom dibaca berurutan dari atas ke bawah. `Padding` 16 piksel memberi ruang dari tepi layar, sedangkan `SizedBox` memisahkan judul, petunjuk, dan input. `SingleChildScrollView` memungkinkan pengguna menjangkau semua input serta tombol Simpan saat layar sempit atau keyboard mengurangi ruang yang tersedia. `Scaffold` menyesuaikan area body saat keyboard muncul. Isi dialog juga dapat digulir agar ringkasan panjang tetap terbaca.

4. **Validasi formulir.** `GlobalKey<FormState>` memberi akses ke state `Form`. Saat Simpan ditekan, `validate()` menjalankan seluruh `validator` dan menampilkan pesan pada kolom terkait. Dialog hanya dibuka jika semuanya valid. Institusi dan program studi wajib diisi, input spasi ditolak, dan panjang dibatasi 100 karakter setelah trim. Tahun wajib berupa empat digit antara 1900 dan tahun berjalan; tahun selesai tidak boleh mendahului tahun mulai. Contohnya, tahun mulai `2024` dan tahun selesai `2023` ditolak. `TextInputType.number` hanya memilih keyboard yang sesuai, bukan menjamin data valid; teks hasil paste atau input keyboard fisik tetap harus diperiksa.

#### Implementasi dan cara mencoba

Bagian portofolio yang dipilih adalah **riwayat edukasi yang telah diselesaikan**. Halaman baru berada di `lib/screens/education_form.dart`, menggunakan `StatefulWidget`, `Form`, dan `GlobalKey<FormState>`. Empat atributnya adalah nama institusi, program studi, tahun mulai, dan tahun selesai. Tahun disimpan sebagai input tahun, sehingga memakai keyboard angka. Form ini tidak memiliki atribut tanggal lengkap atau URL.

1. Jalankan `flutter pub get`, kemudian `flutter run` dari direktori utama repositori.
2. Tekan kartu **Tambah Edukasi** atau pilih **Tambah Edukasi** pada drawer.
3. Tekan **Simpan** tanpa mengisi data untuk melihat pesan kesalahan; coba juga spasi, nama di atas 100 karakter, tahun bukan angka, atau urutan tahun terbalik.
4. Isi contoh valid: `SMA Contoh`, `IPA`, `2022`, `2025`. Tekan Simpan untuk melihat seluruh nilai dalam dialog. **Tutup** mengembalikan pengguna ke form dengan isian tetap tersedia untuk diedit. Data hanya ditampilkan dalam dialog dan belum disimpan secara permanen.
5. Gunakan Back perangkat setelah membuka form dari kartu. Gunakan **Home** pada drawer untuk kembali ke menu di Chrome. Opsi **Add Project** tetap membuka form proyek sebelumnya.
6. Ulangi pada layar ponsel dengan keyboard terbuka; gulir sampai tombol Simpan.

Pemeriksaan otomatis:

```sh
flutter analyze --no-pub
flutter test --no-pub
```

`test/education_form_test.dart` mencakup akses kartu dan Back, drawer menuju edukasi/proyek/Home, semua aturan validasi, isi dialog dan perubahan isian setelah dialog ditutup, serta layar 320 × 568 dengan inset keyboard. Pengujian tutorial sebelumnya tetap berada di `test/widget_test.dart`.

#### Keterangan penggunaan AI dan log prompting

 Dalam pengerjaan Tugas 8, saya menggunakan OpenAI Codex sebagai alat bantu untuk memahami konsep Flutter, memberikan saran implementasi, serta membantu mengidentifikasi dan memperbaiki kesalahan pada kode.

AI juga digunakan untuk membantu memahami penggunaan widget, navigasi antarhalaman, dan validasi formulir. Hasil bantuan AI tetap ditinjau dan disesuaikan dengan kebutuhan tugas serta materi yang telah dipelajari.

Contoh prompt yang digunakan:

"Bantu jelaskan cara membuat form input menggunakan StatefulWidget dan GlobalKey<FormState> di Flutter."

"Bagaimana cara melakukan validasi input tahun agar tahun selesai tidak lebih kecil dari tahun mulai?"

"Bantu periksa kode Flutter saya dan berikan saran perbaikan jika terdapat error."

"Jelaskan penggunaan Navigator.push dan Navigator.pushReplacement untuk navigasi antarhalaman."

Peran AI: Sebagai alat bantu pembelajaran, referensi teknis, dan debugging dalam proses pengembangan aplikasi.