import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatefulWidget {
  final String filePath;
  final String title;

  const PdfViewerScreen({
    super.key,
    required this.filePath,
    required this.title,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final PdfViewerController _controller = PdfViewerController();
  int _currentPage = 1;
  int _totalPages = 0;

  @override
  Widget build(BuildContext context) {
    final file = File(widget.filePath);
    final exists = file.existsSync();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, overflow: TextOverflow.ellipsis),
        actions: [
          if (_totalPages > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Text(
                  '$_currentPage / $_totalPages',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: () => _controller.zoomLevel =
                (_controller.zoomLevel + 0.25).clamp(1.0, 3.0),
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: () => _controller.zoomLevel =
                (_controller.zoomLevel - 0.25).clamp(1.0, 3.0),
          ),
        ],
      ),
      body: !exists
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  const Text('File not found'),
                  const SizedBox(height: 8),
                  Text(
                    widget.filePath,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : SfPdfViewer.file(
              file,
              controller: _controller,
              onDocumentLoaded: (details) {
                setState(() => _totalPages = details.document.pages.count);
              },
              onPageChanged: (details) {
                setState(() => _currentPage = details.newPageNumber);
              },
            ),
    );
  }
}