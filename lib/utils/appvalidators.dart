class AppValidator {

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
