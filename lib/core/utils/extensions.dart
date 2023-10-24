extension StringExtensions on String? {
  bool get isNullOrBlank {
    return this == null || (this?.trim().isEmpty ?? true);
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
