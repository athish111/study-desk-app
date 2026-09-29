import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';    // ← critical import

import '../../models/pdf_material.dart';
import '../../utils/pdf_storage.dart';
import 'pdf_viewer_screen.dart';

class PdfMaterialsScreen extends StatefulWidget {
  const PdfMaterialsScreen({super.key});

  @override
  State<PdfMaterialsScreen> createState() => _PdfMaterialsScreenState();
}

class _PdfMaterialsScreenState extends State<PdfMaterialsScreen> {
  final List<PdfMaterial> _materials = [
    PdfMaterial(
      id: '1',
      title: 'Calculus Chapter 1',
      subjectId: 'Mathematics',
      filePath: '/files/calculus1.pdf',
      fileSize: 2400000,
      uploadedAt: DateTime.now().subtract(const Duration(days: 2)),
      pages: 45,
    ),
    PdfMaterial(
      id: '2',
      title: 'Newton\'s Laws',
      subjectId: 'Physics',
      filePath: '/files/newton.pdf',
      fileSize: 1800000,
      uploadedAt: DateTime.now().subtract(const Duration(days: 5)),
      pages: 32,
    ),
  ];

  bool _isUploading = false;

  Future<void> _pickPdf() async {
  try {
    setState(() => _isUploading = true);

    // New API: no .platform, returns List<PlatformFile> directly
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result.isEmpty) {
      setState(() => _isUploading = false);
      return;
    }

    final pickedFile = result.first;

    if (kIsWeb) {
      final bytes = await pickedFile.readAsBytes();
      _showSnack('Web upload — ${bytes.length} bytes read');
      setState(() {
        _materials.insert(0, PdfMaterial(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: pickedFile.name,
          subjectId: 'General',
          filePath: '',
          fileSize: bytes.length,
          uploadedAt: DateTime.now(),
          isFromDevice: true,
        ));
        _isUploading = false;
      });
      return;
    }

    if (pickedFile.path == null) {
      setState(() => _isUploading = false);
      _showSnack('Could not read file');
      return;
    }

    final savedPath = await PdfStorage.savePdfToAppDir(File(pickedFile.path!));
    final meta = await _askForMetadata(pickedFile.name);

   final fileLength = await File(pickedFile.path!).length();   // ✅ await BEFORE setState

setState(() {
  _materials.insert(0, PdfMaterial(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    title: meta?['title'] ?? pickedFile.name,
    subjectId: meta?['subject'] ?? 'General',
    filePath: savedPath,
    fileSize: fileLength,
    uploadedAt: DateTime.now(),
    isFromDevice: true,
  ));
  _isUploading = false;
});

    _showSnack('PDF uploaded successfully ✅');
  } catch (e) {
    setState(() => _isUploading = false);
    _showSnack('Upload failed: $e');
  }
}

  Future<Map<String, String>?> _askForMetadata(String defaultName) async {
    final titleController = TextEditingController(
      text: defaultName.replaceAll('.pdf', ''),
    );
    final subjectController = TextEditingController(text: 'General');

    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PDF Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(labelText: 'Subject'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, {
              'title': titleController.text.trim(),
              'subject': subjectController.text.trim(),
            }),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> _deletePdf(PdfMaterial m) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete PDF?'),
        content: Text('Remove "${m.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5C5C),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    if (m.isFromDevice && m.filePath.isNotEmpty && !kIsWeb) {
      await PdfStorage.deletePdf(m.filePath);
    }

    setState(() => _materials.removeWhere((x) => x.id == m.id));
    _showSnack('Deleted "${m.title}"');
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Materials')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isUploading ? null : _pickPdf,
        icon: _isUploading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.upload_file),
        label: Text(_isUploading ? 'Uploading...' : 'Upload PDF'),
      ),
      body: _materials.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              itemCount: _materials.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final m = _materials[i];
                return _PdfCard(
                  material: m,
                  sizeText: _formatSize(m.fileSize),
                  onTap: () {
                    if (m.filePath.isEmpty) {
                      _showSnack('No local file (web demo)');
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PdfViewerScreen(
                          filePath: m.filePath,
                          title: m.title,
                        ),
                      ),
                    );
                  },
                  onDelete: () => _deletePdf(m),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.picture_as_pdf_outlined,
              size: 72, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text('No PDFs uploaded yet',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          Text('Tap "Upload PDF" to add your first file',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _pickPdf,
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload PDF'),
          ),
        ],
      ),
    );
  }
}

class _PdfCard extends StatelessWidget {
  final PdfMaterial material;
  final String sizeText;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _PdfCard({
    required this.material,
    required this.sizeText,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF252540) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFF5C5C).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.picture_as_pdf,
                  color: Color(0xFFFF5C5C)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          material.title,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (material.isFromDevice)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00D9A5).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'DEVICE',
                            style: TextStyle(
                              fontSize: 9,
                              color: Color(0xFF00D9A5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${material.subjectId} • ${material.pages > 0 ? "${material.pages} pages • " : ""}$sizeText',
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 20),
              onSelected: (v) {
                if (v == 'delete') onDelete();
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline,
                          size: 18, color: Color(0xFFFF5C5C)),
                      SizedBox(width: 8),
                      Text('Delete',
                          style: TextStyle(color: Color(0xFFFF5C5C))),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}