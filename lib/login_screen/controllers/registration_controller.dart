import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsps_depo/login_screen/utils/dialogs.dart';
import 'package:jsps_depo/services/auth_service.dart';

class RegistrationController extends ChangeNotifier {
  final AuthService _authService = Get.find();

  RxBool isRegisterMode = true.obs;
  RxBool isPasswordHidden = true.obs;
  RxBool isLoading = false.obs;

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String get fullName => fullNameController.text.trim();
  String get email => emailController.text.trim();
  String get password => passwordController.text.trim();

  void toggleRegisterMode() {
    isRegisterMode.value = !isRegisterMode.value;
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> authenticateWithEmailAndPassword() async {
    isLoading.value = true;
    try {
      if (isRegisterMode.value) {
        await _authService.register(
          fullName: fullName,
          email: email,
          password: password,
        );
        await showMessageDialog(
          message:
              'Sağlanan e-posta adresine bir doğrulama e-postası gönderildi. Uygulamaya devam etmek için lütfen e-postanızı doğrulayın.',
        );
        while (!_authService.isEmailVerified) {
          await Future.delayed(const Duration(seconds: 5));
          await _authService.user?.reload();
        }
      } else {
        await _authService.login(email: email, password: password);
      }
    } catch (e) {
      await showMessageDialog(
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> authenticateWithGoogle() async {
    isLoading.value = true;
    try {
      await _authService.signInWithGoogle();
      Get.offAllNamed('/home');
    } catch (e) {
      await showMessageDialog(
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword({required String email}) async {
    isLoading.value = true;
    try {
      await _authService.resetPassword(email: email);
      await showMessageDialog(
        message:
            '$email adresine şifre sıfırlama bağlantısı gönderildi. Şifrenizi sıfırlamak için bağlantıyı açın.',
      );
    } catch (e) {
      await showMessageDialog(
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
