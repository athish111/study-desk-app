class PdfMaterial {
  final String id;
  final String title;
  final String subjectId;
  final String filePath;
  final int fileSize;
  final DateTime uploadedAt;
  final int pages;
  final bool isFromDevice;

  PdfMaterial({
    required this.id,
    required this.title,
    required this.subjectId,
    required this.filePath,
    required this.fileSize,
    required this.uploadedAt,
    this.pages = 0,
    this.isFromDevice = false,
  });
}