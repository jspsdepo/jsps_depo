import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsps_depo/pages/deneme_sorulari/deneme_sorulari.dart';
import 'package:jsps_depo/themes/box_decoration.dart';

class DenemeButton extends StatelessWidget {
  const DenemeButton({required this.buttonText, super.key});
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          Get.to(() => const DenemeEkrani());
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: CustomBoxTheme.getBoxShadowDecoration(theme),
          child: Center(
            child: Text(
              buttonText,
              style: theme.textTheme.titleLarge,
            ),
          ),
        ),
      ),
    );
  }
}

class DenemeSorularEkrani extends StatelessWidget {
  const DenemeSorularEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deneme Soruları Çöz'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DenemeButton(buttonText: 'Deneme 1'),
            DenemeButton(buttonText: 'Deneme 2'),
            DenemeButton(buttonText: 'Deneme 3'),
            DenemeButton(buttonText: 'Deneme 4'),
            DenemeButton(buttonText: 'Deneme 5'),
          ],
        ),
      ),
    );
  }
}
