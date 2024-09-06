import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsps_depo/firebase_storage/file_storage_service.dart';
import 'package:jsps_depo/firebase_storage/storage_service.dart';
import 'package:jsps_depo/jsps_depom_icons.dart';
import 'package:jsps_depo/pages/json_screen/json_view.dart';
import 'package:jsps_depo/pages/pdf_view/pdf_view_widget.dart';
import 'package:jsps_depo/themes/box_decoration.dart';

class FilesScreen extends StatelessWidget {
  const FilesScreen({
    required this.folder,
    required this.parentFolder,
    required this.subFolder,
    super.key,
  });

  final String folder;
  final String parentFolder;
  final String subFolder;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FilesScreenController>(
      init: FilesScreenController(folder: folder),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(folder),
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (controller.groupedFilesMap.isEmpty) {
              return const Center(child: Text('Dosya bulunamadı.'));
            } else {
              return buildFileListWidget(
                controller.groupedFilesMap,
                controller,
              );
            }
          }),
        );
      },
    );
  }

  Widget buildFileListWidget(
    Map<String, List<LocalFileItem>> groupedFiles,
    FilesScreenController controller,
  ) {
    final fileGroups = groupedFiles.entries.toList();

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!controller.isLoadingMore.value &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          controller.loadMoreFiles();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: fileGroups.length + (controller.isLoadingMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == fileGroups.length) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final fileGroup = fileGroups[index];
          final fileNameWithoutExtension = fileGroup.key;
          final files = fileGroup.value;
          final isDownloaded =
              files.any((file) => controller.isFileDownloaded(file.name));

          return Card(
            elevation: 0,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              decoration:
                  CustomBoxTheme.getBoxShadowDecoration(Theme.of(context)),
              child: ListTile(
                title: Text(fileNameWithoutExtension),
                trailing: isDownloaded
                    ? IconButton(
                        icon: const Icon(JspsDepom.delete),
                        onPressed: () =>
                            controller.deleteFile(fileNameWithoutExtension),
                      )
                    : IconButton(
                        icon: const Icon(JspsDepom.download),
                        onPressed: () => controller.showFormatSelectionDialog(
                          context,
                          files,
                        ),
                      ),
                onTap: () =>
                    controller.showFormatSelectionDialog(context, files),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FilesScreenController extends GetxController {
  final String folder;
  late final FileStorageService fileStorageService;
  late final StorageService storageService;
  RxMap<String, List<LocalFileItem>> groupedFilesMap =
      <String, List<LocalFileItem>>{}.obs;
  RxList<LocalFileItem> downloadedFiles = <LocalFileItem>[].obs;
  RxBool isConnected = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isLoading = true.obs;
  int itemsPerPage = 20;
  int currentPage = 1;

  FilesScreenController({required this.folder});

  @override
  void onInit() {
    super.onInit();
    fileStorageService = FileStorageService();
    storageService = StorageService();
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    final result = await Connectivity().checkConnectivity();
    bool wasConnected = isConnected.value;
    isConnected.value = result != ConnectivityResult.none;

    await fetchFiles();

    if (!wasConnected && isConnected.value) {
      updateFilesInBackground();
    }
  }

  Future<void> updateFilesInBackground() async {
    try {
      final files = await storageService.listFilesWithPaths(folder);
      groupedFilesMap.value = groupFilesByName(files);
    } catch (error) {
      debugPrint('Arka planda dosya güncellerken hata oluştu: $error');
    }
  }

  Future<void> fetchFiles() async {
    try {
      final localFilesGrouped =
          await fileStorageService.listLocalFilesGroupedByFolder();
      downloadedFiles.value = localFilesGrouped[folder] ?? [];

      if (isConnected.value) {
        final files = await storageService.listFilesWithPaths(folder);
        final groupedFiles = groupFilesByName(files);

        groupedFiles.forEach((key, value) {
          if (groupedFilesMap.containsKey(key)) {
            groupedFilesMap[key]!.addAll(value);
          } else {
            groupedFilesMap[key] = value;
          }
        });

        groupedFilesMap.forEach((key, value) {
          groupedFilesMap[key] = value.toSet().toList();
        });
      } else {
        groupedFilesMap.value = groupFilesByName(downloadedFiles);
      }

      isLoading.value = false;
    } catch (error) {
      debugPrint('Dosyalar yüklenirken hata oluştu: $error');
      if (groupedFilesMap.isEmpty) {
        groupedFilesMap.value = {};
      }
      isLoading.value = false;
    }
  }

  Map<String, List<LocalFileItem>> groupFilesByName(List<LocalFileItem> files) {
    final Map<String, List<LocalFileItem>> groupedFiles = {};

    for (final file in files) {
      String fileNameWithoutExtension = file.name.split('.').first;

      if (groupedFiles.containsKey(fileNameWithoutExtension)) {
        groupedFiles[fileNameWithoutExtension]!.add(file);
      } else {
        groupedFiles[fileNameWithoutExtension] = [file];
      }
    }

    return groupedFiles;
  }

  Future<void> loadMoreFiles() async {
    if (isLoadingMore.value || !isConnected.value) return;

    isLoadingMore.value = true;

    try {
      final files = await storageService.listFilesWithPaths(folder);
      currentPage++;
      final additionalFiles = files
          .skip((currentPage - 1) * itemsPerPage)
          .take(itemsPerPage)
          .toList();
      final newGroupedFiles = groupFilesByName(additionalFiles);

      newGroupedFiles.forEach((key, value) {
        if (groupedFilesMap.containsKey(key)) {
          groupedFilesMap[key]!.addAll(value);
          groupedFilesMap[key] = groupedFilesMap[key]!.toSet().toList();
        } else {
          groupedFilesMap[key] = value;
        }
      });

      isLoadingMore.value = false;
    } catch (error) {
      debugPrint('Daha fazla dosya yüklenirken hata oluştu: $error');
      isLoadingMore.value = false;
    }
  }

  Future<void> deleteFile(String fileName) async {
    final confirmDelete = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Dosyayı Sil?'),
        content: Text('$fileName dosyasını silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('İPTAL'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('SİL', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      final formats = ['json', 'pdf'];
      for (final format in formats) {
        final localFiles = downloadedFiles
            .where((file) => file.name == '$fileName.$format')
            .toList();
        if (localFiles.isNotEmpty) {
          for (final file in localFiles) {
            try {
              final filePath = file.path;
              final localFile = File(filePath);
              if (await localFile.exists()) {
                await localFile.delete();
                showSnackBar('${file.name} silindi.');
              } else {
                showSnackBar('Dosya bulunamadı: $filePath');
              }
            } catch (error) {
              showSnackBar('Dosya silinirken hata oluştu: $error');
            }
          }
        }
      }
      await fetchFiles();
    }
  }

  void showSnackBar(String message) {
    Get.snackbar(
      'Bilgi',
      message,
      duration: const Duration(seconds: 2),
    );
  }

  bool isFileDownloaded(String fileName) {
    return downloadedFiles.any((file) => file.name == fileName);
  }

  void showFormatSelectionDialog(
    BuildContext context,
    List<LocalFileItem> files,
  ) {
    final formats =
        files.map((file) => file.name.split('.').last).toSet().toList();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          margin: EdgeInsets.zero,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration:
                CustomBoxTheme.getBoxShadowDecoration(Theme.of(context)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Format Seçin',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: formats.map((format) {
                      String formatTitle;
                      if (format == 'json') {
                        formatTitle = 'Okuma Modunda Aç';
                      } else if (format == 'pdf') {
                        formatTitle = 'Pdf Modunda Aç';
                      } else {
                        formatTitle = '${format.toUpperCase()} Olarak Aç';
                      }

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                              onTapFile(
                                files
                                    .firstWhere(
                                      (file) => file.name.endsWith(format),
                                    )
                                    .name,
                                format,
                              );
                            },
                            child:
                                Text(formatTitle, textAlign: TextAlign.center),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onTapFile(String fileName, String format) async {
    var localFile = await fileStorageService.loadLocalFile(fileName, folder);

    if (localFile == null && isConnected.value) {
      try {
        final url = await storageService.getDownloadUrl(folder, fileName);
        localFile =
            await fileStorageService.downloadFile(url, fileName, folder);
        if (localFile != null) {
          debugPrint('Dosya indirildi: ${localFile.path}');
          await openFile(localFile.path, fileName, format);
          await fetchFiles();
        }
      } catch (e) {
        showSnackBar('Dosya indirilemedi: $e');
      }
    } else if (localFile != null) {
      debugPrint('Yerel dosya açılıyor: ${localFile.path}');
      await openFile(localFile.path, fileName, format);
    } else {
      showSnackBar('Dosya indirilemedi ve yerel olarak bulunamadı.');
    }
  }

  Future<void> openFile(String filePath, String fileName, String format) async {
    debugPrint('Dosya açılıyor: $filePath');

    if (format == 'json') {
      final jsonString = await File(filePath).readAsString();
      await Get.to(
        () => Jsonpdfviewer(
          jsonString: jsonString,
          fileName: fileName,
          pdfUrl: '',
          folder: folder,
        ),
      );
    } else if (format == 'pdf') {
      await Get.to(
        () => PDFViewWidget(
          pdfUrl: filePath,
          fileName: fileName,
          folder: folder,
        ),
      );
    }
  }
}
