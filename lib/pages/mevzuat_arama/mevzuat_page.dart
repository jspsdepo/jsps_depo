import 'package:flutter/material.dart';
import 'package:jsps_depo/base_state.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MevzuatEkrani extends StatefulWidget {
  const MevzuatEkrani({super.key});

  @override
  _MevzuatEkraniState createState() => _MevzuatEkraniState();
}

class _MevzuatEkraniState extends BaseState<MevzuatEkrani> {
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
      ..addJavaScriptChannel(
        'appChannel',
        onMessageReceived: (JavaScriptMessage message) {},
      )
      ..loadRequest(Uri.parse('https://www.mevzuat.gov.tr'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: kToolbarHeight,
        ), // App bar yüksekliği kadar boşluk bırakır
        child: WebViewWidget(
          controller: _controller,
        ),
      ),
    );
  }
}
