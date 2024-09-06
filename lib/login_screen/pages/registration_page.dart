import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsps_depo/jsps_depom_icons.dart';
import 'package:jsps_depo/login_screen/controllers/registration_controller.dart';
import 'package:jsps_depo/login_screen/pages/recover_password_page.dart';
import 'package:jsps_depo/login_screen/utils/validator.dart';
import 'package:jsps_depo/login_screen/widgets/note_button.dart';
import 'package:jsps_depo/login_screen/widgets/note_form_field.dart';
import 'package:jsps_depo/login_screen/widgets/note_icon_button_outlined.dart';

class RegistrationPage extends StatelessWidget {
  final RegistrationController controller = Get.put(RegistrationController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        controller.isRegisterMode.value
                            ? 'Kayıt Ol'
                            : 'Giriş Yap',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Uygulamaya girmek için kayıt olmanız/giriş yapmanız gerekmektedir.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 32),
                      if (controller.isRegisterMode.value)
                        NoteFormField(
                          controller: controller.fullNameController,
                          hintText:
                              'Tam Ad', // label yerine hintText kullanıldı
                          validator: Validator.nameValidator,
                        ),
                      const SizedBox(height: 8),
                      NoteFormField(
                        controller: controller.emailController,
                        hintText: 'E-posta', // label yerine hintText kullanıldı
                        keyboardType: TextInputType.emailAddress,
                        validator: Validator.emailValidator,
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => NoteFormField(
                          controller: controller.passwordController,
                          hintText: 'Şifre', // label yerine hintText kullanıldı
                          obscureText: controller.isPasswordHidden.value,
                          suffixIcon: GestureDetector(
                            onTap: controller.togglePasswordVisibility,
                            child: Icon(
                              controller.isPasswordHidden.value
                                  ? JspsDepom.eye
                                  : JspsDepom.eyeoff,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          validator: Validator.passwordValidator,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (!controller.isRegisterMode.value)
                        GestureDetector(
                          onTap: () {
                            Get.to(() => RecoverPasswordPage());
                          },
                          child: Text(
                            'Şifremi Unuttum?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      Obx(
                        () => NoteButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.authenticateWithEmailAndPassword,
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator()
                              : Text(
                                  controller.isRegisterMode.value
                                      ? 'Hesabımı Oluştur'
                                      : 'Giriş Yap',
                                  style: theme.textTheme.labelLarge,
                                ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: NoteIconButtonOutlined(
                            icon: JspsDepom.google,
                            onPressed: controller.authenticateWithGoogle,
                            label: '',
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text.rich(
                        TextSpan(
                          text: controller.isRegisterMode.value
                              ? 'Zaten bir hesabınız var mı? '
                              : 'Hesabınız yok mu?',
                          style: theme.textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: controller.isRegisterMode.value
                                  ? 'Giriş Yap'
                                  : 'Kayıt Ol',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = controller.toggleRegisterMode,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
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
