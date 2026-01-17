import 'package:flutter/material.dart';

void main() {
  runApp(const Lab4());
}

class Lab4 extends StatelessWidget {
  const Lab4({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Lab 4 – Flutter UI Fundamental',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildMenuCard("Exercise 1 – Core Widgets Demo"),
              _buildMenuCard("Exercise 2 – Input Controls Demo"),
              _buildMenuCard("Exercise 3 – Layout Demo"),
              _buildMenuCard("Exercise 4 – App Structure & Theme"),
              _buildMenuCard("Exercise 5 – Common UI Fixes"),
              _buildMenuCard("Exercise 6 – Performance"),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- CARD ITEM ----------
  Widget _buildMenuCard(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
