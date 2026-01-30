extension StringExtensions on String {
  String get capitalize {
    if (trim().isEmpty) return "";
    return trim()
        .split(RegExp(r'\s+'))
        .map((word) {
          if (word.isEmpty) return "";
          return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
        })
        .join(' ');
  }
}
