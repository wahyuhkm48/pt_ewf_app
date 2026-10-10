// utils/histori_excel_exporter.dart
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/histori_data_model.dart';

class HistoriExcelExporter {
  /// Membuat file .xlsx dari [data] lalu membuka share sheet
  /// (user bisa "Simpan ke File", Google Drive, WhatsApp, dll).
  static Future<void> export({
    required String namaProduk,
    required List<HistoriDataModel> data,
  }) async {
    final excel = Excel.createExcel();

    // Ganti nama sheet bawaan ("Sheet1") jadi nama aset
    final defaultSheet = excel.getDefaultSheet();
    if (defaultSheet != null) {
      excel.rename(defaultSheet, namaProduk);
    }
    final sheet = excel[namaProduk];
    sheet.setColumnWidth(0, 16.0);

    // Header
    sheet.appendRow([
      TextCellValue('Tanggal'),
      TextCellValue('Open'),
      TextCellValue('High'),
      TextCellValue('Low'),
      TextCellValue('Close'),
    ]);

    // Isi data (urutan sama seperti di layar: terbaru di atas)
    for (final d in data) {
      sheet.appendRow([
        TextCellValue(_formatTanggal(d.tanggal)),
        DoubleCellValue(d.open),
        DoubleCellValue(d.high),
        DoubleCellValue(d.low),
        DoubleCellValue(d.close),
      ]);
    }

    final bytes = excel.encode();
    if (bytes == null) {
      throw Exception('Gagal membuat file Excel');
    }

    final dir = await getTemporaryDirectory();
    final namaFile = 'histori_${namaProduk.toLowerCase()}_${_stamp(DateTime.now())}.xlsx';
    final file = File('${dir.path}/$namaFile');
    await file.writeAsBytes(bytes, flush: true);

    await Share.shareXFiles(
      [
        XFile(
          file.path,
          mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        ),
      ],
      subject: 'Data Historis $namaProduk',
      text: 'Data Historis $namaProduk - EQUITYWORLD',
    );
  }

  static String _two(int v) => v.toString().padLeft(2, '0');

  static String _formatTanggal(DateTime d) => '${d.year}-${_two(d.month)}-${_two(d.day)}';

  static String _stamp(DateTime d) => '${d.year}${_two(d.month)}${_two(d.day)}';
}