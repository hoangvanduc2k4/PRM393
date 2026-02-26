class Name {
  String firstName;
  String lastName;
  Name(this.firstName, this.lastName);
}

main() {
  Name name = new Name('mark', 'smith');
  print(name.firstName);
  print(name.lastName);
}
