import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsps_depo/pages/home_screen/controller/home_screen_controller.dart';

class HomeScreenIcons extends StatelessWidget {
  HomeScreenIcons({super.key});

  final HomeScreenController controller = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return GridView.builder(
      itemCount: controller.icons.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (context, index) {
        final iconData = controller.icons[index];
        final color = isDarkTheme
            ? iconData['colorDark'] as Color
            : iconData['colorLight'] as Color;

        return GestureDetector(
          onTap: () => Get.to(iconData['page']! as Widget Function()),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 100,
                  height: 100,
                  color: color,
                  child: Center(
                    child: Icon(
                      iconData['icon'] as IconData,
                      size: 100,
                      color: isDarkTheme ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
