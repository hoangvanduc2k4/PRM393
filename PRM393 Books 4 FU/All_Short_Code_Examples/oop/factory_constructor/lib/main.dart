class Printer {
  static final Printer _singleton = Printer._construct();
  factory Printer() {
    return _singleton;
  }
  Printer._construct() {
    print('private constructor');
  }
  printSomething(String text) {
    print(text);
  }
}

void main() {
  Printer().printSomething("this");
  Printer().printSomething("and");
  Printer().printSomething("that");
}
