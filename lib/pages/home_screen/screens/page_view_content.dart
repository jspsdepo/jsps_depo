import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsps_depo/pages/home_screen/controller/page_view_controller.dart';
import 'package:jsps_depo/themes/box_decoration.dart';
import 'package:url_launcher/url_launcher.dart';

class PageViewContent extends StatelessWidget {
  PageViewContent({super.key});

  final PageViewContentController controller =
      Get.put(PageViewContentController());

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'URL açılamadı: $urlString';
      }
    } catch (e) {
      Get.defaultDialog(
        title: 'Hata',
        content: Text('URL açılırken bir hata oluştu: $e'),
        textConfirm: 'Tamam',
        onConfirm: () => Get.back(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [];
    for (final imageUrl in controller.imageUrls) {
      pages.add(
        Image.asset(
          imageUrl,
          fit: BoxFit.cover,
        ),
      );
    }

    pages.add(
      Obx(() {
        if (controller.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              final item = controller.items[index];
              return Container(
                margin: const EdgeInsets.all(8),
                decoration:
                    CustomBoxTheme.getBoxShadowDecoration(Theme.of(context)),
                child: ListTile(
                  title: Text(item['title']!),
                  onTap: () => _launchURL(item['url']!),
                ),
              );
            },
          );
        }
      }),
    );

    return SizedBox(
      child: PageView(
        children: pages,
      ),
    );
  }
}
