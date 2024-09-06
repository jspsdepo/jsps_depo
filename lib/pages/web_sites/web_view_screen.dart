import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jsps_depo/base_state.dart';
import 'package:jsps_depo/themes/box_decoration.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YararliSiteler extends StatefulWidget {
  const YararliSiteler({super.key});

  @override
  _YararliSitelerState createState() => _YararliSitelerState();
}

class _YararliSitelerState extends BaseState<YararliSiteler> {
  final List<SiteInfo> siteInfoList = [
    SiteInfo(
      url: 'https://www.tccb.gov.tr/',
      name: 'Türkiye Cumhuriyeti Cumhurbaşkanlığı',
    ),
    SiteInfo(url: 'https://www.icisleri.gov.tr/', name: 'İçişleri Bakanlığı'),
    SiteInfo(url: 'https://www.adalet.gov.tr/', name: 'Adalet Bakanlığı'),
    SiteInfo(url: 'https://www.msb.gov.tr/', name: 'Milli Savunma Bakanlığı'),
    SiteInfo(
      url: 'https://www.jandarma.gov.tr/',
      name: 'Jandarma Genel Komutanlığı',
    ),
    SiteInfo(url: 'https://www.egm.gov.tr/', name: 'Emniyet Genel Müdürlüğü'),
    SiteInfo(
      url: 'https://www.tbmm.gov.tr/',
      name: 'Türkiye Büyük Millet Meclisi',
    ),
    SiteInfo(url: 'https://www.resmigazete.gov.tr/', name: 'Resmî Gazete'),
    SiteInfo(url: 'https://www.afad.gov.tr/', name: 'AFAD'),
    SiteInfo(url: 'https://www.kizilay.org.tr/', name: 'Türk Kızılayı'),
  ];

  @override
  void initState() {
    super.initState();
    _enterFullScreen();
  }

  void _enterFullScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersive,
        overlays: [],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yararlı Siteler'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: siteInfoList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final siteInfo = siteInfoList[index];
          return GestureDetector(
            onTap: () {
              _openWebView(siteInfo.url);
            },
            child: Container(
              decoration: CustomBoxTheme.getBoxShadowDecoration(theme),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      siteInfo.name,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      siteInfo.url,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openWebView(String url) {
    Navigator.of(context).push(
      MaterialPageRoute<Widget>(
        builder: (context) => WebPage(url: url),
      ),
    );
  }
}

class WebPage extends StatefulWidget {
  const WebPage({required this.url, super.key});
  final String url;

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}

class SiteInfo {
  SiteInfo({required this.url, required this.name});
  final String url;
  final String name;
}
