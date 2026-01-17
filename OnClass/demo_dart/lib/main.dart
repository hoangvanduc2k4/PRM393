Future<String> fetchData() async {
  await Future.delayed(const Duration(seconds: 2));
  return "Data loaded successfully";
}

Stream<int> numberStream() async* {
  for (int i = 1; i <= 3; i++) {
    yield i;
  }
}

Future<void> main() async {
  print("Fetching...");
  String result = await fetchData();
  print(result);

  String? username;
  String finalName = username ?? "Guest";
  print("Username after ?? = $finalName");

  username = "Duc";
  print("Username after assign = ${username!}");

  await for (int value in numberStream()) {
    print("Stream value: $value");
  }
}
