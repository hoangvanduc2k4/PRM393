import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  int multiplyMethod1(int a, int b) => a * b;
  int multiplyMethod2(int a, int b) => a * b;

  @override
  Widget build(BuildContext context) {
    // giống hệt print(multiplyMethod1(2,4))
    final result1 = multiplyMethod1(2, 4);
    final result2 = multiplyMethod2(6, 8);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Multiply Fixed Values"),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: Text(
            "multiplyMethod1(2,4) = $result1\n"
            "multiplyMethod2(2,4) = $result2",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
