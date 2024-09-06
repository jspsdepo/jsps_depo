import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsps_depo/login_screen/controllers/registration_controller.dart';
import 'package:jsps_depo/login_screen/utils/validator.dart';

import 'package:jsps_depo/login_screen/widgets/note_button.dart';
import 'package:jsps_depo/login_screen/widgets/note_form_field.dart';

class RecoverPasswordPage extends StatelessWidget {
  final RegistrationController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Get.back()),
        title: const Text('Şifre Kurtarma'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Merak etmeyin! En iyilerimize bile olur!',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Form(
                child: Column(
                  children: [
                    NoteFormField(
                      controller: controller.emailController,
                      filled: true,
                      labelText: 'E-posta',
                      validator: Validator.emailValidator,
                    ),
                    const SizedBox(height: 24),
                    Obx(
                      () => SizedBox(
                        height: 48,
                        child: NoteButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                                  controller.resetPassword(
                                    email: controller.email,
                                  );
                                },
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(),
                                )
                              : const Text('Kurtarma bağlantısı gönder!'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
