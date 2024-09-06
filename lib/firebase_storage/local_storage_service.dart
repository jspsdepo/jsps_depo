import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService extends GetxService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  Future<void> saveFolders(List<String> folders) async {
    final foldersString = jsonEncode(folders);
    await _prefs.setString('folders', foldersString);
  }

  Future<List<String>?> loadFolders() async {
    final foldersString = _prefs.getString('folders');
    if (foldersString != null) {
      final foldersList = jsonDecode(foldersString) as List<dynamic>;
      return foldersList.cast<String>();
    }
    return null;
  }
}
