import 'dart:async';
import 'dart:convert';

// ======================================================
//               EXERCISE 1 – PRODUCT REPOSITORY
// ======================================================

class Product {
  final int id;
  final String name;
  final double price;

  Product(this.id, this.name, this.price);

  @override
  String toString() => "Product(id: $id, name: $name, price: $price)";
}

class ProductRepository {
  final List<Product> _products = [];
  final _controller = StreamController<Product>.broadcast();

  // Future lấy tất cả sản phẩm
  Future<List<Product>> getAll() async {
    await Future.delayed(Duration(milliseconds: 300)); // mô phỏng API
    return _products;
  }

  // Stream phát sự kiện thêm sản phẩm
  Stream<Product> liveAdded() => _controller.stream;

  // thêm sản phẩm và phát event
  void addProduct(Product p) {
    _products.add(p);
    _controller.add(p);
  }
}

Future testExercise1() async {
  print("\n=== EXERCISE 1: PRODUCT REPOSITORY ===");

  final repo = ProductRepository();

  // Lắng nghe thêm sản phẩm mới
  repo.liveAdded().listen((p) {
    print("STREAM EVENT → New product added: $p");
  });

  repo.addProduct(Product(1, "Laptop", 1200));
  repo.addProduct(Product(2, "Mouse", 25));

  final all = await repo.getAll();
  print("Future result → All products: $all");
}

// ======================================================
//               EXERCISE 2 – JSON USER REPO
// ======================================================

class User {
  final String name;
  final String email;

  User(this.name, this.email);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json["name"], json["email"]);
  }

  @override
  String toString() => "User(name: $name, email: $email)";
}

class UserRepository {
  Future<List<User>> fetchUsers() async {
    await Future.delayed(Duration(milliseconds: 300));

    // JSON mô phỏng từ API
    String jsonData = '''
    [
      {"name": "Alice", "email": "alice@mail.com"},
      {"name": "Bob", "email": "bob@mail.com"}
    ]
    ''';

    List<dynamic> raw = json.decode(jsonData);
    return raw.map((x) => User.fromJson(x)).toList();
  }
}

Future testExercise2() async {
  print("\n=== EXERCISE 2: USER JSON PARSING ===");

  final repo = UserRepository();
  List<User> users = await repo.fetchUsers();

  print("Parsed Users:");
  for (var u in users) {
    print(" → $u");
  }
}

// ======================================================
//     EXERCISE 3 – ASYNC + MICROTASK EXECUTION ORDER
// ======================================================

void testExercise3() {
  print("\n=== EXERCISE 3: MICROTASK vs FUTURE ORDER ===");

  print("1. Start main");

  scheduleMicrotask(() {
    print("2. Microtask executed (runs BEFORE event queue)");
  });

  Future(() {
    print("3. Future event executed");
  });

  Future(() {
    print("4. Another Future event");
  });

  print("5. End main (but microtasks & futures still pending)");
}

// Expected execution order:
// 1 → 5 → 2 → 3 → 4

// ======================================================
//           EXERCISE 4 – STREAM TRANSFORMATION
// ======================================================

void testExercise4() {
  print("\n=== EXERCISE 4: STREAM TRANSFORMATION ===");

  Stream<int> numberStream = Stream.fromIterable([
    1,
    2,
    3,
    4,
    5,
  ]); // input stream

  numberStream
      .map((x) => x * x) // bình phương
      .where((x) => x % 2 == 0) // lọc số chẵn
      .listen((value) => print("Emitted: $value"));

  // Expected output:
  // 4, 16
}

// ======================================================
//        EXERCISE 5 – FACTORY CONSTRUCTOR + CACHE
// ======================================================

class Settings {
  static Settings? _instance;

  // private constructor
  Settings._internal();

  factory Settings() {
    _instance ??= Settings._internal();
    return _instance!;
  }

  String theme = "light";
}

void testExercise5() {
  print("\n=== EXERCISE 5: FACTORY SINGLETON CACHE ===");

  final s1 = Settings();
  final s2 = Settings();

  print("s1 identical s2 ? → ${identical(s1, s2)}"); // expected: true

  s1.theme = "dark";
  print("s2.theme should also be 'dark' → ${s2.theme}");
}

// ======================================================
//                       MAIN
// ======================================================

void main() async {
  await testExercise1();
  await testExercise2();
  testExercise3();
  testExercise4();
  testExercise5();
}
