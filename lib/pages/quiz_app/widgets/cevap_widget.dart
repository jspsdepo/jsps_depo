import 'package:flutter/material.dart';

class CevapWidget extends StatelessWidget {
  const CevapWidget({
    required this.cevapMetni,
    required this.onPressed,
    this.seciliMi = false,
    this.dogruMu,
    this.yanlisMi,
    super.key,
  });

  final String cevapMetni;
  final VoidCallback onPressed;
  final bool seciliMi;
  final bool? dogruMu;
  final bool? yanlisMi;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var backgroundColor = theme.colorScheme.primary;
    if (dogruMu == true) {
      backgroundColor = Colors.green;
    } else if (yanlisMi == true) {
      backgroundColor = Colors.red;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [backgroundColor, backgroundColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Text(
          cevapMetni,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
