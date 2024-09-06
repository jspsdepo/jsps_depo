import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:jsps_depo/firebase_storage/local_storage_service.dart';
import 'package:jsps_depo/firebase_storage/storage_service.dart';

class AdliKollukController extends GetxController {
  late final LocalStorageService _localStorageService;
  late final StorageService _storageService;
  RxList<String> folders = <String>[].obs;
  RxBool isLoading = true.obs;

  List<String> desiredFolders = [
    'Adli Kolluk Bilgileri',
  ];

  @override
  void onInit() {
    super.onInit();
    _localStorageService = Get.find<LocalStorageService>();
    _storageService = Get.find<StorageService>();
    _initServices();
  }

  Future<void> _initServices() async {
    await loadFoldersFromLocalStorage();
    await checkInternetAndFetchFolders();
  }

  Future<void> checkInternetAndFetchFolders() async {
    final List<ConnectivityResult> result =
        await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      await fetchFolders();
    }
  }

  Future<void> fetchFolders() async {
    try {
      final List<String> folderList = await _storageService.listRootFolders();
      folders.value = folderList
          .where((folder) => desiredFolders.contains(folder))
          .toList();
      await _localStorageService.saveFolders(folders);
      isLoading.value = false;
    } catch (error) {
      print('Klasörleri çekerken hata oluştu: $error');
    }
  }

  Future<void> loadFoldersFromLocalStorage() async {
    final List<String>? savedFolders = await _localStorageService.loadFolders();
    folders.value = savedFolders ?? desiredFolders;
    isLoading.value = false;
  }
}
