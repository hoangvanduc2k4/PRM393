class Person {
  String firstName;
  String lastName;
  int age;
  Person(this.firstName, this.lastName, this.age);
}

main() {
  Person p = new Person('mark', 'smith', 22);
  print('The persons name is ${p.firstName} ${p.lastName} and he is ${p.age}');
}
