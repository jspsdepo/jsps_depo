import 'package:flutter/material.dart';
import 'package:jsps_depo/base_state.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ResmiGazete extends StatefulWidget {
  const ResmiGazete({super.key});

  @override
  _ResmiGazeteState createState() => _ResmiGazeteState();
}

class _ResmiGazeteState extends BaseState<ResmiGazete> {
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
      ..loadRequest(Uri.parse('https://www.resmigazete.gov.tr'));
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
