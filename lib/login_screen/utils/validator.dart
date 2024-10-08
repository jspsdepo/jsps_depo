class Validator {
  Validator._();

  static String? nameValidator(String? name) {
    name = name?.trim() ?? '';
    return name.isEmpty ? 'Ad girilmedi!' : null;
  }

  static const String _emailPattern =
      r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';

  static String? emailValidator(String? email) {
    email = email?.trim() ?? '';
    return email.isEmpty
        ? 'E-posta girilmedi!'
        : !RegExp(_emailPattern).hasMatch(email)
            ? 'E-posta geçerli bir format değil!'
            : null;
  }

  static String? passwordValidator(String? password) {
    password = password ?? '';
    var errorMessage = '';
    if (password.isEmpty) {
      errorMessage = 'Şifre girilmedi!';
    } else {
      if (password.length < 6) {
        errorMessage = 'Şifre en az 6 karakter uzunluğunda olmalıdır!';
      }
      if (!password.contains(RegExp('[a-z]'))) {
        errorMessage += '\nŞifre en az bir küçük harf içermelidir';
      }
      if (!password.contains(RegExp('[A-Z]'))) {
        errorMessage += '\nŞifre en az bir büyük harf içermelidir';
      }
      if (!password.contains(RegExp('[0-9]'))) {
        errorMessage += '\nŞifre en az bir rakam içermelidir';
      }
    }
    return errorMessage.isNotEmpty ? errorMessage.trim() : null;
  }
}
