import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:jsps_depo/firebase_storage/file_storage_service.dart';
import 'package:jsps_depo/firebase_storage/storage_service.dart';

class PDFViewWidget extends StatefulWidget {
  const PDFViewWidget({
    required this.pdfUrl,
    required this.fileName,
    required this.folder,
    super.key,
  });

  final String pdfUrl;
  final String fileName;
  final String folder;

  @override
  State<PDFViewWidget> createState() => _PDFViewWidgetState();
}

class _PDFViewWidgetState extends State<PDFViewWidget> {
  bool _isLoading = true;
  String? _localFilePath;

  @override
  void initState() {
    super.initState();
    _loadPdfFile();
  }

  Future<void> _loadPdfFile() async {
    try {
      final localFile = await FileStorageService().loadLocalFile(
        widget.fileName,
        widget.folder,
      );
      if (localFile == null) {
        final fileUrl = await StorageService().getDownloadUrl(
          widget.folder,
          widget.fileName,
        );
        final file = await FileStorageService().downloadFile(
          fileUrl,
          widget.fileName,
          widget.folder,
        );
        if (file == null) throw Exception('File download failed');
        _localFilePath = file.path;
      } else {
        _localFilePath = localFile.path;
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('Dosya indirilemedi: $e');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Lütfen bekleyiniz, PDF indiriliyor...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          : PDFView(
              filePath: _localFilePath,
            ),
    );
  }
}
