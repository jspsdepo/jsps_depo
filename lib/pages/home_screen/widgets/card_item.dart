import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  const CardItem({
    required this.iconData,
    required this.onTap,
    required this.colorDark,
    required this.colorLight,
    super.key,
  });

  final IconData iconData;
  final void Function(BuildContext) onTap;
  final Color colorDark;
  final Color colorLight;

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDarkTheme ? colorDark : colorLight;

    return Card(
      elevation: 0,
      child: Material(
        child: InkWell(
          onTap: () => onTap(context),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 150,
                height: 150,
                color: backgroundColor,
                child: Center(
                  child: Transform.scale(
                    scaleX: 1, // Yatay eksende büyütme
                    child: Icon(
                      iconData,
                      size: 150,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
