// utils/png_exporter.dart
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class PngExporter {
  /// Ubah isi RepaintBoundary (yang ditunjuk [key]) menjadi bytes PNG.
  /// [pixelRatio] 3 = tajam (lebar sekitar 1100 px di HP biasa).
  static Future<Uint8List> capture(GlobalKey key, {double pixelRatio = 3}) async {
    final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      throw Exception('Area hasil belum siap diekspor.');
    }

    // Di mode debug, boundary yang belum selesai digambar tidak boleh di-capture.
    if (boundary.debugNeedsPaint) {
      await Future.delayed(const Duration(milliseconds: 30));
    }

    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();

    if (data == null) {
      throw Exception('Gagal membuat gambar.');
    }
    return data.buffer.asUint8List();
  }

  /// Simpan ke folder sementara lalu buka share sheet
  /// (sama seperti ekspor Excel: Simpan ke File/Foto, WhatsApp, dll).
  static Future<void> share(
    Uint8List bytes, {
    required String namaFile,
    String? subject,
    String? text,
  }) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$namaFile.png');
    await file.writeAsBytes(bytes, flush: true);

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'image/png')],
      subject: subject,
      text: text,
    );
  }
}