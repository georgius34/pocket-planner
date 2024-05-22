class AppValidator {
  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Isi email';
    }
    RegExp emailRegExp = RegExp(r'[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value!.isEmpty) {
      return 'Isi phone number';
    }
    if (value.length != 10) {
      return 'Please enter a 10-digit phone number';
    }
    return null;
  }

  String? validateUsename(String? value) {
    if (value!.isEmpty) {
      return 'Harus ada isi';
    }
    return null;
  }

  String? isEmptyCheck(String? value) {
    if (value!.isEmpty) {
      return 'Harus ada data';
    }
    return null;
  }

  String? validateAmount(String? value) {
    if (value!.isEmpty) {
      return 'Harus ada data';
    }
    String digits = value.replaceAll(RegExp(r'[Rp,. ]'), '');
    if (digits.isEmpty || !RegExp(r'^\d+$').hasMatch(digits)) {
      return 'Masukkan jumlah yang valid';
    }
    return null;
  }
}
