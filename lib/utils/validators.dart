/// Common input validation helpers.
class Validators {
  /// Returns true when the value is non-null and not blank.
  static bool isNotEmpty(String? value) =>
      value != null && value.trim().isNotEmpty;
}
