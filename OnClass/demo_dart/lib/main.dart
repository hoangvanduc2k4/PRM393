import 'dart:async';
import 'dart:math';

import 'person.dart';

void main() {
  Person p = Person('Mark', 'Smith', 22);
  print(
    'The person\'s name is ${p.firstName} ${p.lastName} and he is ${p.age}',
  );
}

String reverseString(String text) {
  var result = '';
  for (int i = text.length - 1; i >= 0; i--) {
    result += text[i];
  }
  return result;
}

int countWord(String text, String c) {
  int count = 0;
  for (int i = 0; i < text.length; i++) {
    if (text[i] == c) count++;
  }
  return count;
}

int findMax(List<int> numbers) {
  if (numbers.isEmpty) {
    return 0;
  }
  int max = numbers[0];
  for (int i = 0; i < numbers.length; i++) {
    if (numbers[i] > max) {
      max = numbers[i];
    }
  }
  return max;
}

int countPrime(int start, int end) {
  int count = 0;
  for (int i = start; i <= end; i++) {
    if (isPrime(i)) count++;
  }
  return count;
}

bool isPrime(int n) {
  if (n <= 1) return false;
  for (int i = 2; i <= sqrt(n); i++) {
    if (n % i == 0) return false;
  }
  return true;
}

List<T> removeDuplicates<T>(List<T> list) {
  Set<T> newSet = list.toSet();
  return newSet.toList();
}

bool isPalindrome(String s) {
  String rev = s.split('').reversed.join('');
  return rev.toLowerCase() == s.toLowerCase();
}

Map<String, int> charFrequency(String text) {
  Map<String, int> dict = {};

  for (int i = 0; i < text.length; i++) {
    if (dict.containsKey(text[i])) {
      dict[text[i]] = dict[text[i]]! + 1;
    } else {
      dict[text[i]] = 1;
    }
  }

  return dict;
}

List<String> sortByLength(List<String> words) {
  words.sort((a, b) => a.length.compareTo(b.length));
  return words;
}

List<String> getEvenOddWords(List<int> numbers) {
  List<String> result = numbers
      .map((x) => x % 2 == 0 ? 'even' : 'odd')
      .toList();
  return result;
}

Future<String> delayedGreeting(String name) {
  return Future.delayed(Duration(seconds: 2), () => 'Hello $name');
}

class Employee {
  final String name;
  final double salary;

  Employee(this.name, this.salary);

  void work() {
    print("$name is working...");
  }
}

class Manager extends Employee {
  final int teamSize;

  Manager(String name, double salary, this.teamSize) : super(name, salary);

  @override
  void work() {
    print("$name is managing a team of $teamSize people...");
  }
}
