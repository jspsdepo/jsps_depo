import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsps_depo/jsps_depom_icons.dart';
import 'package:jsps_depo/login_screen/widgets/note_icon_button_outlined.dart';

class NoteBackButton extends StatelessWidget {
  const NoteBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: NoteIconButtonOutlined(
        icon: JspsDepom.arrowback,
        onPressed: () {
          Get.back();
        },
        label: 'Go back',
      ),
    );
  }
}
