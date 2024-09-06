import 'package:flutter/material.dart';

class CustomBoxTheme {
  static BoxDecoration getBoxShadowDecoration(ThemeData theme) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: LinearGradient(
        colors: [
          theme.primaryColor.withOpacity(0.85), // Birincil rengin yumuşak tonu
          theme.colorScheme.secondary
              .withOpacity(0.65), // İkincil rengin yumuşak tonu
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.02), // İnce siyah gölge
          spreadRadius: 1,
          blurRadius: 8,
          offset: const Offset(1, 2), // Hafif yükseklik ve gölge konumu
        ),
        BoxShadow(
          color: theme.primaryColor
              .withOpacity(0.05), // Hafif birincil renk gölgesi
          spreadRadius: 1,
          blurRadius: 16,
          offset:
              const Offset(-1, -2), // Hafif negatif yükseklik ve gölge konumu
        ),
      ],
      border: Border.all(
        color: theme.colorScheme.secondary
            .withOpacity(0.5), // Daha belirgin sınır rengi
        width: 2, // Daha kalın sınır kalınlığı
      ),
    );
  }
}
