import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jsps_depo/jsps_depom_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({
    required this.currentName,
    required this.currentProfilePicture,
    super.key,
  });

  final String currentName;
  final String currentProfilePicture;

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _nameController;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _nameController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: widget.currentName.length,
    );
    if (widget.currentProfilePicture.isNotEmpty) {
      _profileImage = File(widget.currentProfilePicture);
    }
  }

  Future<void> _pickImage() async {
    var cameraStatus = await Permission.camera.status;
    var galleryStatus = await Permission.photos.status;

    if (cameraStatus.isDenied || galleryStatus.isDenied) {
      _showPermissionDialog();
      return;
    }

    if (!cameraStatus.isGranted) {
      cameraStatus = await Permission.camera.request();
    }
    if (!galleryStatus.isGranted) {
      galleryStatus = await Permission.photos.request();
    }

    if (cameraStatus.isGranted && galleryStatus.isGranted) {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } else {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('İzin Gerekli'),
        content: const Text(
          'Fotoğraf yükleyebilmek için galeri ve kamera erişim izni vermelisiniz.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
            child: const Text('Ayarları Aç'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _nameController.text);
    if (_profileImage != null) {
      await prefs.setString('profileImage', _profileImage!.path);
    } else {
      await prefs.remove('profileImage');
    }
  }

  Future<void> _removeImage() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resmi Kaldır'),
        content:
            const Text('Profil resmini kaldırmak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _profileImage = null;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Kaldır'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Düzenle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _profileImage != null && _profileImage!.existsSync()
                          ? FileImage(_profileImage!)
                          : null,
                  child: _profileImage == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: const CircleAvatar(
                      radius: 16,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            JspsDepom.cameraalt,
                            size: 10,
                          ),
                          Text(
                            'Yükle',
                            style: TextStyle(
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_profileImage != null)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: GestureDetector(
                      onTap: _removeImage,
                      child: const CircleAvatar(
                        radius: 16,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              JspsDepom.delete,
                              size: 10,
                            ),
                            Text(
                              'Kaldır',
                              style: TextStyle(
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'İsim',
                suffixIcon: _nameController.text.isEmpty
                    ? const Icon(JspsDepom.user_edit)
                    : IconButton(
                        icon: const Icon(JspsDepom.clear),
                        onPressed: () {
                          _nameController.clear();
                        },
                      ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _saveProfileData();
                Get.back(
                  result: {
                    'name': _nameController.text,
                    'profileImage': _profileImage?.path,
                  },
                );
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
