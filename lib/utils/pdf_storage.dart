import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class PdfStorage {
  /// Copies the picked PDF into the app's documents folder
  /// so it survives app restarts.
  static Future<String> savePdfToAppDir(File sourceFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final pdfDir = Directory(p.join(appDir.path, 'pdfs'));

    if (!await pdfDir.exists()) {
      await pdfDir.create(recursive: true);
    }

    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${p.basename(sourceFile.path)}';
    final newPath = p.join(pdfDir.path, fileName);

    await sourceFile.copy(newPath);
    return newPath;
  }

  /// Deletes a stored PDF file (used when the user removes it)
  static Future<void> deletePdf(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}