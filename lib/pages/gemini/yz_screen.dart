import 'package:flutter/material.dart';
import 'package:jsps_depo/pages/gemini/chat_screen.dart';
import 'package:jsps_depo/pages/yuzdehesapla/yuzde_hesapla.dart';
import 'package:jsps_depo/themes/box_decoration.dart';

class YZScreen extends StatelessWidget {
  const YZScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yapay Zeka Araçları'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildCard(
            context,
            title: 'Gemini Chat Ai',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatScreen(title: 'Chat Ekranı'),
                ),
              );
            },
          ),
          _buildCard(
            context,
            title: 'Yüzde Hesaplama',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PercentageCalculatorPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: CustomBoxTheme.getBoxShadowDecoration(Theme.of(context)),
      child: ListTile(
        title: Text(title),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
