import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 4 – Flutter UI Fundament...'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildButton('Exercise 1 – Core Widgets Demo'),
          _buildButton('Exercise 2 – Input Controls Demo'),
          _buildButton('Exercise 3 – Layout Demo'),
          _buildButton('Exercise 4 – App Structure & Theme'),
          _buildButton('Exercise 5 – Common UI Fixes'),
        ],
      ),
    );
  }

  Widget _buildButton(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {}, // Chưa học Navigator nên để trống
      ),
    );
  }
}
