class Settings {
  static Settings? _instance;

  Settings._internal();

  factory Settings() {
    _instance ??= Settings._internal();
    return _instance!;
  }

  String theme = "light";
}

void main() {
  final s1 = Settings();
  final s2 = Settings();

  print("Identical: ${identical(s1, s2)}");

  s1.theme = "dark";
  print("s2 theme: ${s2.theme}");
}
