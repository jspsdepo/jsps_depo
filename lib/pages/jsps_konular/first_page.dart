import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsps_depo/firebase_storage/files_screen.dart';
import 'package:jsps_depo/pages/jsps_konular/folder_controller.dart';
import 'package:jsps_depo/themes/box_decoration.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sadece FolderController'ı çağırmak
    final folderController = Get.put(FolderController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Klasörler'),
      ),
      body: Obx(() {
        if (folderController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (folderController.folders.isEmpty) {
          return const Center(child: Text('Klasör bulunamadı.'));
        } else {
          return buildListSeparated(
            folderController.folders,
            Theme.of(context),
          );
        }
      }),
    );
  }

  Widget buildListSeparated(List<String> folders, ThemeData theme) {
    return ListView.separated(
      itemCount: folders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final folder = folders[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: CustomBoxTheme.getBoxShadowDecoration(
              theme,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                folder,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<Widget>(
                    builder: (context) => FilesScreen(
                      folder: folder,
                      parentFolder: '',
                      subFolder: '',
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
