# Trust by Equityworld — Aplikasi Flutter

Aplikasi mobile pendamping perdagangan berjangka komoditi: kalkulator (Pivot Point, Nest, Emas Fisik), live chart, data historis, dan berita pasar global. Dibangun dengan Flutter dan terhubung ke backend Laravel (di-deploy di Vercel) dengan database Supabase.

> Nama package Dart: `equityworld`. Nama yang tampil ke pengguna: **Trust by Equityworld**.

---

## Fitur

| Area | Keterangan |
|---|---|
| **Autentikasi** | Login & registrasi (nama, email, no. telepon, password). Token disimpan aman di `flutter_secure_storage`. |
| **Home** | Sapaan, berita hot (carousel), dan 5 riwayat perhitungan terbaru dari Pivot Point, Nest, dan Emas Fisik. |
| **Kalkulator** | Dibuka dari tombol tengah bottom nav (speed dial): **Pivot Point / Nest** (halaman Konsep Transaksi) dan **Emas Fisik**. |
| **History** | Tab Pivot Point, Nest, dan Emas Fisik. Tiap item bisa dibuka ke halaman detail hasil perhitungan. |
| **Chart** | Chart TradingView (WebView) untuk Gold, JPK (Nikkei), dan HKK (Hang Seng) + ekspor data historis ke Excel (.xlsx). |
| **Berita** | Daftar Hot News dan halaman detail dengan tombol "Baca Selengkapnya" ke sumber asli. |
| **Settings** | Account Information (edit nama, no. telp, foto profil), Password, Notification, Language, Help, About, dan Logout. |

### Indikator Action

- **Pivot Point**: `PP > Open` = BUY, `PP < Open` = SELL.
- **Nest**: `Close kemarin > Open hari ini` = BUY, `Close kemarin < Open hari ini` = SELL.
- Nilai sama persis ditampilkan sebagai NETRAL.

### Alur Halaman

```text
Splash (animasi bubble → logo)
   └─ Onboarding ("Get Started")
        └─ Welcome ── Login ─┐
                     └─ Sign Up ─┴─► MainShell (Home · History · Chart · Settings)
```

---

## Tech Stack

- **Flutter** (Dart SDK `^3.11.5`, sesuai `pubspec.yaml`)
- **State management**: `provider` (pola MVVM dengan `ChangeNotifier`)
- **HTTP**: `http`
- **Penyimpanan token**: `flutter_secure_storage`
- **Chart**: `webview_flutter` (TradingView)
- **Font**: `google_fonts` (Inter)
- **Lainnya**: `image_picker` (foto profil), `url_launcher` (buka link berita), `excel` + `path_provider` + `share_plus` (ekspor Excel), `flutter_launcher_icons` (dev, generate icon)

---

## Arsitektur & Struktur Folder

Menggunakan pola **MVVM**: `View` → `ViewModel` → `Service` → `ApiClient`.

```text
lib/
├── main.dart              # Entry point + registrasi Provider
├── core/
│   └── api_client.dart    # HTTP client, base URL, header, penanganan error
├── models/                # Model data (Employee, PivotPoint, Nest, EmasFisik, News, dst.)
├── services/              # Pemanggil endpoint API per domain
├── viewmodels/            # State & logika per fitur (ChangeNotifier)
├── views/                 # Halaman (splash, onboarding, welcome, login, home, history, chart, settings, dst.)
├── widgets/               # Widget reusable (ActionBadge, MiniStat, LevelRow, AvatarRing, dst.)
├── utils/                 # Helper (page transitions, form errors, ekspor Excel, label aset, dst.)
└── theme/                 # AppColors & AppTextStyles
```

---

## Prasyarat

- Flutter SDK yang mendukung Dart `^3.11.5` (cek dengan `flutter --version`)
- Android Studio / VS Code dengan plugin Flutter & Dart
- Emulator atau perangkat fisik (Android / iOS)
- Backend yang sudah berjalan (lihat bagian **Konfigurasi API**)

---

## Instalasi & Menjalankan

```bash
# 1. Pasang dependency
flutter pub get

# 2. Cek environment
flutter doctor

# 3. Jalankan aplikasi
flutter run
```

> Setelah mengubah daftar `assets:` di `pubspec.yaml`, lakukan **stop lalu run ulang** (bukan hot reload / hot restart) agar asset ter-bundle.

---

## Konfigurasi API

Base URL backend ditulis langsung di `lib/core/api_client.dart`:

```dart
static const String baseUrl = 'https://pt-ewf-backend.vercel.app/api';
```

Untuk development lokal atau staging, ganti nilainya ke URL backend yang sesuai (contoh emulator Android ke Laravel lokal: `http://10.0.2.2:8000/api`).

Setiap request membawa header:

- `Accept: application/json`
- `X-Client: flutter`
- `Authorization: Bearer <token>` (otomatis, bila sudah login)

### Endpoint yang dipakai aplikasi

| Method | Endpoint | Fungsi |
|---|---|---|
| POST | `/login`, `/register` | Autentikasi (publik) |
| POST | `/logout` | Logout |
| GET | `/me` | Data akun yang login |
| POST / GET | `/pivot-point/hitung`, `/pivot-point` | Hitung & riwayat Pivot Point |
| POST / GET | `/nest/hitung`, `/nest` | Hitung & riwayat Nest |
| POST / GET | `/emas-fisik/hitung`, `/emas-fisik` | Hitung & riwayat Emas Fisik |
| GET | `/histori/gold`, `/histori/nikkei`, `/histori/hangseng` | Data historis harga |
| GET | `/news` | Berita pasar |
| GET | `/market/harga` | Harga pasar terkini |
| PUT | `/profile` | Update nama & no. telepon |
| POST | `/profile/foto` | Upload foto profil (multipart) |
| PUT | `/profile/password` | Ganti password |

Semua endpoint selain `/login` dan `/register` memerlukan token (Laravel Sanctum).

---

## Asset

Asset didaftarkan di `pubspec.yaml`. Yang dipakai saat ini:

```text
assets/images/logo_trustByEwf.png       # Logo utama (Trust by Equityworld)
assets/images/onboarding_building.png   # Background onboarding & welcome
assets/images/lowprofile-highprofit.png
assets/images/rectangle 1351.png
assets/images/icons/pivot_point.png
assets/images/icons/emas_fisik.png
assets/images/ewf_logo.png              # Logo lama (hapus jika sudah tidak dipakai)
```

### Mengganti icon aplikasi

Konfigurasi ada di blok `flutter_launcher_icons` pada `pubspec.yaml`. Setelah mengganti gambar:

```bash
dart run flutter_launcher_icons
```

Gunakan gambar persegi (ideal 1024×1024). Uninstall aplikasi lama dari perangkat sebelum install ulang, karena icon launcher sering ter-cache.

### Mengganti nama aplikasi di home screen

- **Android**: `android/app/src/main/AndroidManifest.xml` → `android:label`
- **iOS**: `ios/Runner/Info.plist` → `CFBundleDisplayName` dan `CFBundleName`

---

## Perizinan Platform

**Android** — pastikan izin internet ada di `android/app/src/main/AndroidManifest.xml` (wajib untuk build release, karena izin ini hanya otomatis ada di build debug):

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

**iOS** — di `ios/Runner/Info.plist`, untuk fitur ganti foto profil:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Aplikasi membutuhkan akses galeri untuk mengganti foto profil</string>
```

---

## Build Rilis

```bash
# Android APK
flutter build apk --release

# Android App Bundle (untuk Play Store)
flutter build appbundle --release

# iOS (butuh macOS + Xcode)
flutter build ipa --release
```

Hasil build Android ada di `build/app/outputs/`. Untuk rilis ke Play Store / App Store, siapkan signing key terlebih dahulu sesuai dokumentasi resmi Flutter.

---

## Troubleshooting

| Masalah | Solusi |
|---|---|
| Gambar/asset tidak muncul | Pastikan terdaftar di `pubspec.yaml`, jalankan `flutter pub get`, lalu stop & run ulang aplikasi. |
| `LateInitializationError` setelah edit State | Gunakan **Hot Restart**, bukan Hot Reload. |
| Request API gagal di build release (Android) | Cek izin `INTERNET` di `AndroidManifest.xml`. |
| Icon launcher tidak berubah | Uninstall aplikasi lama, jalankan `dart run flutter_launcher_icons`, install ulang. |
| Upload foto profil gagal | Pastikan format JPG/PNG dan ukuran maksimal 2 MB; cek konfigurasi Supabase Storage di backend. |
| Chart TradingView blank | Periksa koneksi internet; chart dimuat lewat WebView dari server TradingView. |

---

## Catatan Pengembangan

- Tema warna dan tipografi terpusat di `lib/theme/` — ubah di sana, bukan per halaman.
- Gunakan Hot Restart saat mengubah field di `State`, karena Hot Reload tidak menjalankan ulang `initState()`.
- Jangan ubah `name: equityworld` di `pubspec.yaml` kecuali siap mengganti seluruh import `package:equityworld/...`.
