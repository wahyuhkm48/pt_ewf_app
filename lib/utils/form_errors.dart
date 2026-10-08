// utils/form_errors.dart
import 'dart:async';
import 'package:http/http.dart' as http;
import '../core/api_client.dart';

// ======================================================================
// Util teks
// ======================================================================

/// ['A'] -> "A" | ['A','B'] -> "A dan B" | ['A','B','C'] -> "A, B, dan C"
String gabungKolom(List<String> items) {
  if (items.isEmpty) return '';
  if (items.length == 1) return items.first;
  if (items.length == 2) return '${items[0]} dan ${items[1]}';
  return '${items.sublist(0, items.length - 1).join(', ')}, dan ${items.last}';
}

// ======================================================================
// Tahap 1: ada kolom yang kosong?
// ======================================================================

/// [kolom] = nama kolom -> isinya.
/// Mengembalikan pesan kalau ada yang kosong, atau null kalau semua terisi.
String? pesanKolomKosong(Map<String, String> kolom) {
  final kosong = kolom.entries
      .where((e) => e.value.trim().isEmpty)
      .map((e) => e.key)
      .toList();

  if (kosong.isEmpty) return null;
  if (kosong.length == kolom.length) {
    return 'Semua kolom masih kosong. Mohon isi ${gabungKolom(kosong)} terlebih dahulu.';
  }
  return 'Mohon isi kolom ${gabungKolom(kosong)} terlebih dahulu.';
}

// ======================================================================
// Tahap 2: ada isian yang salah? (tampilkan SEMUA yang salah + alasannya)
// ======================================================================

String? pesanKolomSalah(List<String> masalah) {
  if (masalah.isEmpty) return null;
  return 'Periksa kembali isian kamu:\n${masalah.map((m) => '• $m').join('\n')}';
}

// ---- alasan per jenis kolom (null = isian benar) ----

String? alasanEmailSalah(String email) {
  final e = email.trim();
  if (e.contains(' ')) return 'tidak boleh mengandung spasi.';
  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$').hasMatch(e)) {
    return 'format tidak valid, contoh: nama@email.com.';
  }
  return null;
}

/// Buang spasi dan strip: "0812-3456 7890" -> "081234567890"
String normalisasiTelp(String raw) => raw.replaceAll(RegExp(r'[\s-]'), '');

String? alasanTelpSalah(String raw) {
  final n = normalisasiTelp(raw);
  if (!RegExp(r'^\+?[0-9]+$').hasMatch(n)) {
    return 'hanya boleh berisi angka, dan tanda + hanya di awal.';
  }
  final digit = n.startsWith('+') ? n.length - 1 : n.length;
  if (digit < 8) return 'terlalu pendek, minimal 8 digit (sekarang $digit digit).';
  if (digit > 15) return 'terlalu panjang, maksimal 15 digit (sekarang $digit digit).';
  return null;
}

String? alasanPasswordSalah(String password) {
  if (password.length < 8) {
    return 'minimal 8 karakter (sekarang ${password.length} karakter).';
  }
  return null;
}

// ======================================================================
// Validasi per halaman: null = lolos, selain itu = teks untuk peringatan merah
// ======================================================================

String? validasiLogin({required String email, required String password}) {
  final kosong = pesanKolomKosong({'Email': email, 'Password': password});
  if (kosong != null) return kosong;

  final masalah = <String>[];
  final e = alasanEmailSalah(email);
  if (e != null) masalah.add('Email: $e');
  return pesanKolomSalah(masalah);
}

String? validasiRegister({
  required String nama,
  required String email,
  required String telp,
  required String password,
  required String konfirmasi,
}) {
  final kosong = pesanKolomKosong({
    'Nama Lengkap': nama,
    'Email': email,
    'Nomor Telepon': telp,
    'Password': password,
    'Konfirmasi Password': konfirmasi,
  });
  if (kosong != null) return kosong;

  final masalah = <String>[];
  if (nama.trim().length > 255) {
    masalah.add('Nama Lengkap: terlalu panjang, maksimal 255 karakter.');
  }
  final e = alasanEmailSalah(email);
  if (e != null) masalah.add('Email: $e');
  final t = alasanTelpSalah(telp);
  if (t != null) masalah.add('Nomor Telepon: $t');
  final p = alasanPasswordSalah(password);
  if (p != null) masalah.add('Password: $p');
  if (password != konfirmasi) {
    masalah.add('Konfirmasi Password: tidak sama dengan password.');
  }
  return pesanKolomSalah(masalah);
}

String? validasiGantiPassword({
  required String sekarang,
  required String baru,
  required String konfirmasi,
}) {
  final kosong = pesanKolomKosong({
    'Password Saat Ini': sekarang,
    'Password Baru': baru,
    'Konfirmasi Password Baru': konfirmasi,
  });
  if (kosong != null) return kosong;

  final masalah = <String>[];
  final p = alasanPasswordSalah(baru);
  if (p != null) masalah.add('Password Baru: $p');
  if (baru != konfirmasi) {
    masalah.add('Konfirmasi Password Baru: tidak sama dengan password baru.');
  }
  return pesanKolomSalah(masalah);
}

// ======================================================================
// Error dari server / jaringan -> bahasa Indonesia yang ramah
// ======================================================================

String pesanError(Object e) {
  if (e is ApiException) return _terjemahkanServer(e.message);

  final s = e.toString();
  if (e is TimeoutException ||
      e is http.ClientException ||
      s.contains('SocketException') ||
      s.contains('Failed host lookup')) {
    return 'Tidak dapat terhubung ke server. Periksa koneksi internet kamu lalu coba lagi.';
  }
  if (e is FormatException) {
    return 'Server mengirim respons yang tidak dikenali. Coba lagi beberapa saat lagi.';
  }
  return 'Terjadi kesalahan. Coba lagi.';
}

String _terjemahkanServer(String pesan) {
  final low = pesan.toLowerCase();

  // jangan bocorkan detail teknis (SQL, stack trace) ke layar user
  if (low.contains('sqlstate') || low == 'server error') {
    return 'Terjadi gangguan di server. Coba lagi beberapa saat lagi.';
  }
  if (low.contains('has already been taken')) {
    return 'Email sudah terdaftar. Gunakan email lain atau langsung login.';
  }
  if (low.contains('must be a valid email')) return 'Format email tidak valid.';
  if (low.contains('at least 8 characters')) return 'Password minimal 8 karakter.';
  if (low.contains('confirmation does not match')) {
    return 'Konfirmasi password tidak sama dengan password.';
  }
  if (low.contains('field is required')) {
    return 'Masih ada kolom wajib yang belum diisi.';
  }
  if (low.contains('unauthenticated')) {
    return 'Sesi login kamu sudah berakhir. Silakan login ulang.';
  }
  if (low.contains('too many')) {
    return 'Terlalu banyak percobaan. Tunggu sebentar lalu coba lagi.';
  }

  // pesan dari backend yang sudah berbahasa Indonesia
  // (mis. "Email atau password salah.", "Password saat ini salah.")
  return pesan;
}