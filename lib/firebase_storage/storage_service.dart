import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:jsps_depo/firebase_storage/file_storage_service.dart';

class StorageService extends GetxService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<Map<String, List<String>>> getSelectedFolderContents(
    List<String> selectedFolders,
  ) async {
    final folderContents = <String, List<String>>{};
    for (final folder in selectedFolders) {
      final subFolders = await listSubFolders(folder);
      final files = await listFilesWithPaths(folder);
      folderContents[folder] = [...subFolders, ...files.map((f) => f.name)];
    }
    return folderContents;
  }

  Future<List<String>> listSubFolders(String folderPath) async {
    final result = await storage.ref(folderPath).listAll();
    final subFolders = <String>[];
    for (final prefix in result.prefixes) {
      subFolders.add(prefix.name);
    }
    return subFolders;
  }

  Future<List<String>> listAllFolders() async {
    final folders = await listRootFolders();
    final subFolders = <String>[];

    for (final folder in folders) {
      subFolders.addAll(await _listSubFolders('/$folder'));
    }

    return [...folders, ...subFolders];
  }

  Future<List<String>> _listSubFolders(String folderPath) async {
    final result = await storage.ref(folderPath).listAll();
    final folders = <String>[];
    for (final prefix in result.prefixes) {
      final subFolder = '$folderPath/${prefix.name}';
      folders
        ..add(subFolder)
        ..addAll(await _listSubFolders(subFolder));
    }
    return folders;
  }

  Future<List<LocalFileItem>> listFilesWithPaths(String folderPath) async {
    final result = await storage.ref(folderPath).listAll();
    final fileItems = <LocalFileItem>[];
    for (final item in result.items) {
      final filePath = '$folderPath/${item.name}';
      fileItems.add(
        LocalFileItem(name: item.name, path: filePath, folder: folderPath),
      );
    }
    return fileItems;
  }

  Future<List<String>> listRootFolders() async {
    final listResult = await storage.ref().listAll();
    final folderPrefixes =
        listResult.prefixes.map((prefix) => prefix.name).toList();
    return folderPrefixes;
  }

  Future<String> getDownloadUrl(String folderPath, String fileName) async {
    final fileRef = storage.ref('$folderPath/$fileName');
    return await fileRef.getDownloadURL();
  }
}
