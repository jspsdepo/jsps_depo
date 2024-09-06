import 'dart:developer';
import 'package:translator_plus/translator_plus.dart';

class APIs {
  static Future<String> googleTranslate({
    required String from,
    required String to,
    required String text,
  }) async {
    try {
      // Google Translate API'si için doğru şekilde bir GoogleTranslator instance'ı oluşturduğunuzdan emin olun
      final res = await GoogleTranslator().translate(text, from: from, to: to);

      return res.text;
    } catch (e) {
      log('googleTranslateE: $e ');
      return 'Something went wrong!';
    }
  }
}
