import 'package:flutter/material.dart';

import 'menu_screen.dart';

// Import các file của bạn vào đây (nếu để chung 1 file thì không cần import)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 4 Demo',
      home: const MenuScreen(),
    );
  }
}
