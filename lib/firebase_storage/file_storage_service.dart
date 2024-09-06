import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class FileStorageService extends GetxService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  String sanitizeFileName(String fileName) {
    final invalidChars = RegExp(r'[\\/:*?"<>|]');
    return fileName.replaceAll(invalidChars, '_');
  }

  Future<File?> downloadFile(String url, String fileName, String folder) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final cleanedFileName = sanitizeFileName(fileName);
        final directoryPath = '${await _localPath}/$folder';
        final directory = Directory(directoryPath);

        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }

        final filePath = '$directoryPath/$cleanedFileName';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        print('Failed to download file: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error downloading file: $error');
      return null;
    }
  }

  Future<File?> loadLocalFile(String fileName, String folder) async {
    final path = await _localPath;
    final file = File('$path/$folder/$fileName');
    return file.existsSync() ? file : null;
  }

  Future<List<LocalFileItem>> listLocalFilesWithPaths() async {
    final path = await _localPath;
    final dir = Directory(path);
    final List<LocalFileItem> files = [];

    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File &&
          (entity.path.endsWith('.pdf') || entity.path.endsWith('.json'))) {
        files.add(
          LocalFileItem(
            name: entity.path.split('/').last,
            path: entity.path,
            folder: entity.parent.path.split('/').last,
          ),
        );
      }
    }
    return files;
  }

  Future<Map<String, List<LocalFileItem>>>
      listLocalFilesGroupedByFolder() async {
    final files = await listLocalFilesWithPaths();
    final Map<String, List<LocalFileItem>> groupedFiles = {};

    for (final file in files) {
      if (groupedFiles.containsKey(file.folder)) {
        groupedFiles[file.folder]!.add(file);
      } else {
        groupedFiles[file.folder] = [file];
      }
    }
    return groupedFiles;
  }

  Future<void> deleteFile(String fileName, String folder) async {
    final filePath = '$folder/$fileName';
    final file = File(filePath);

    print('Silinecek dosya yolu: $filePath'); // Dosya yolunu yazdır

    if (await file.exists()) {
      await file.delete();
      print('$fileName silindi');
    } else {
      throw Exception('Dosya bulunamadı: $filePath');
    }
  }
}

class LocalFileItem {
  final String name;
  final String path;
  final String folder;

  LocalFileItem({
    required this.name,
    required this.path,
    required this.folder,
  });
}
