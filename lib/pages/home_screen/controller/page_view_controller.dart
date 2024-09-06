import 'package:get/get.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:http/http.dart' as http;

class PageViewContentController extends GetxController {
  RxList<Map<String, String>> items = <Map<String, String>>[].obs;
  final List<String> imageUrls = [
    'assets/ayyildiz.png',
    // Daha fazla resim yolunu buraya ekleyin
  ];

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  Future<void> fetchItems() async {
    const url = 'https://vatandas.jandarma.gov.tr/ptm/giris';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final document = htmlParser.parse(response.body);
        final spans = document.querySelectorAll('span');
        final filteredSpans = spans
            .where(
              (span) =>
                  span.text.contains('J.GN.K.LIĞI') ||
                  span.text.contains('SONUÇLARI') ||
                  span.text.contains('JANDARMA GENEL KOMUTANLIĞI'),
            )
            .toList();

        items.value = filteredSpans.map((span) {
          return {
            'title': span.text.trim(),
            'url': url,
          };
        }).toList();
      } else {
        throw Exception(
          'Failed to load items. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching items: $e');
    }
  }
}
