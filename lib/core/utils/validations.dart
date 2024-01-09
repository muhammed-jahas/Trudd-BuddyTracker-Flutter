class Validation {
  static String? isEmpty(String? value, String field) =>
      value == null || value.isEmpty ? '$field is Required' : null;

  static String? isNumber(String? value, String field) {
    final hasNumber = RegExp(r'^\d{10}$');
    if (value == null || value.isEmpty) return '$field is Required';
    return hasNumber.hasMatch(value)
        ? null
        : '$field must contain exactly 10 digits';
  }
}
