import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsps_depo/login_screen/widgets/confirmation_dialog.dart';
import 'package:jsps_depo/pages/adli_kolluk/adli_kolluk.dart';
import 'package:jsps_depo/pages/ceviri/translator_feature.dart';
import 'package:jsps_depo/pages/deneme_sorulari/deneme_sorular_ekrani.dart';
import 'package:jsps_depo/pages/gemini/chat_screen.dart';
import 'package:jsps_depo/pages/home_screen/drawer/profile_edit_page.dart';
import 'package:jsps_depo/pages/jsps_konular/first_page.dart';
import 'package:jsps_depo/pages/koordinat/location_widget.dart';
import 'package:jsps_depo/pages/mevzuat_arama/mevzuat_page.dart';
import 'package:jsps_depo/pages/notes/not_list_screen.dart';
import 'package:jsps_depo/pages/quiz_app/screens/sinif_secmek_ekrani.dart';
import 'package:jsps_depo/pages/resmi_gazete/resmi_gazete.dart';
import 'package:jsps_depo/pages/sozluk/format_json.dart';
import 'package:jsps_depo/pages/web_sites/web_view_screen.dart';
import 'package:jsps_depo/services/auth_service.dart';
import 'package:jsps_depo/themes/box_decoration.dart';
import 'package:jsps_depo/themes/theme_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String _userName = 'Kullanıcı Adı';
  String _profilePicture = '';
  List<String> _bookmarkedPages = []; // Kaydedilen sayfalar listesi

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _loadBookmarkedPages(); // Kaydedilen sayfaları yükle
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'Kullanıcı Adı';
      _profilePicture = prefs.getString('profileImage') ?? '';
    });
  }

  Future<void> _loadBookmarkedPages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? bookmarks = prefs.getStringList('bookmarkedPages');
    if (bookmarks != null && bookmarks.isNotEmpty) {
      setState(() {
        _bookmarkedPages = bookmarks;
      });
    }
  }

  Future<void> _showConfirmationDialog() async {
    final result = await Get.dialog<bool>(
      const ConfirmationDialog(
        title: 'Uygulamadan Çıkış Yapmak İstediğinize Emin Misiniz?',
      ),
    );

    if (result == true) {
      final AuthService authService = Get.find<AuthService>();
      await authService.logout();
    }
  }

  Future<void> _editProfile() async {
    final result = await Get.to(
      () => ProfileEditPage(
        currentName: _userName,
        currentProfilePicture: _profilePicture,
      ),
    );

    if (result != null && result is Map) {
      setState(() {
        _userName = result['name'] as String? ?? _userName;
        _profilePicture = result['profileImage'] as String? ?? '';
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (result['profileImage'] == null) {
        await prefs.remove('profileImage');
      } else {
        await prefs.setString('profileImage', result['profileImage'] as String);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Get.find<ThemeNotifier>();
    final isDarkTheme = themeNotifier.themeMode == ThemeMode.dark;
    final theme = Theme.of(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_userName, style: const TextStyle()),
              accountEmail: null,
              currentAccountPicture: CircleAvatar(
                backgroundImage: _profilePicture.isNotEmpty &&
                        File(_profilePicture).existsSync()
                    ? FileImage(File(_profilePicture))
                    : null,
                radius: 10,
                child: _profilePicture.isEmpty ||
                        !File(_profilePicture).existsSync()
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _buildCustomListTile(
                    title: 'JSPS Konular',
                    onTap: () => Get.to(() => const FirstPage()),
                    theme: theme,
                  ),
                  _buildCustomListTile(
                    title: 'Sorular',
                    onTap: () => Get.to(() => const SinifSecmekEkrani()),
                    theme: theme,
                  ),
                  _buildCustomListTile(
                    title: 'Denemeler',
                    onTap: () => Get.to(() => const DenemeSorularEkrani()),
                    theme: theme,
                  ),
                  _buildCustomListTile(
                    title: 'Asayiş Bilgileri',
                    onTap: () => Get.to(() => const AdliKolluk()),
                    theme: theme,
                  ),
                  _buildCustomListTile(
                    title: 'Mevzuat',
                    onTap: () => Get.to(() => const MevzuatEkrani()),
                    theme: theme,
                  ),
                  _buildCustomListTile(
                    title: 'Yararlı Siteler',
                    onTap: () => Get.to(() => const YararliSiteler()),
                    theme: theme,
                  ),
                  _buildCustomListTile(
                    title: 'Resmi Gazete',
                    onTap: () => Get.to(() => const ResmiGazete()),
                    theme: theme,
                  ),
                  _buildCustomListTile(
                    title: 'Y.Z Sohbet',
                    onTap: () => Get.to(() => const ChatScreen(title: '')),
                    theme: theme,
                  ),
                  _buildCustomListTile(
                    title: 'Koordinat Al',
                    onTap: () => Get.to(() => const LocationWidget()),
                    theme: theme,
                  ),
                  _buildCustomListTile(
                    title: 'Sözlük',
                    onTap: () => Get.to(() => const DictionaryScreen()),
                    theme: theme,
                  ),
                  _buildCustomListTile(
                    title: 'Çeviri',
                    onTap: () => Get.to(() => const TranslatorFeature()),
                    theme: theme,
                  ),
                  _buildCustomListTile(
                    title: 'Not Al',
                    onTap: () => Get.to(() => const NotListScreen()),
                    theme: theme,
                  ),
                  const Divider(),
                  _buildCustomListTile(
                    title: isDarkTheme ? 'Açık Mod' : 'Koyu Mod',
                    onTap: themeNotifier.toggleTheme,
                    theme: theme,
                  ),
                  _buildCustomListTile(
                    title: 'Profil Düzenle',
                    onTap: _editProfile,
                    theme: theme,
                  ),
                  _buildCustomListTile(
                    title: 'Çıkış',
                    onTap: _showConfirmationDialog,
                    theme: theme,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomListTile({
    required String title,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return Container(
      decoration: CustomBoxTheme.getBoxShadowDecoration(theme),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      height: 35, // Yüksekliği burada ayarlayabilirsiniz
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft, // Sola yaslamak için
            child: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
