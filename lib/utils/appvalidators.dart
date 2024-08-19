class AppValidator {
  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Email must not be empty';
    }
    RegExp emailRegExp = RegExp(r'[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value!.isEmpty) {
      return 'Phone Number must not be empty';
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
      return 'Data must not be empty';
    }
    return null;
  }

  String? validateAmount(String? value) {
    if (value!.isEmpty) {
      return 'Amount must not be empty';
    }
    String digits = value.replaceAll(RegExp(r'[Rp,. ]'), '');
    if (digits.isEmpty || !RegExp(r'^\d+$').hasMatch(digits)) {
      return 'Please enter a valid amount';
    }
    return null;
  }
  String? validatePeriod(String? value) {
    if (value!.isEmpty) {
      return 'Period must not be empty';
    }
    int? period = int.tryParse(value);
    if (period == null || period < 1 || period > 12) {
      return 'Period must be between 1 and 12';
    }
    return null;
  }
}
