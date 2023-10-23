extension StringExtensions on String? {
  bool get isNullOrBlank {
    return this == null || (this?.trim().isEmpty ?? true);
  }
}
