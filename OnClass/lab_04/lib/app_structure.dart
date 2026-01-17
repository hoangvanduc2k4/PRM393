import 'package:flutter/material.dart';

class AppStructureDemo extends StatefulWidget {
  const AppStructureDemo({super.key});
  @override
  State<AppStructureDemo> createState() => _AppStructureDemoState();
}

class _AppStructureDemoState extends State<AppStructureDemo> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Exercise 4 – App Str...'),
          actions: [
            Row(
              children: [
                const Text('Dark'),
                Switch(
                  value: _isDark,
                  onChanged: (v) => setState(() => _isDark = v),
                ),
              ],
            ),
          ],
        ),
        body: const Center(
          child: Text('This is a simple screen with theme toggle.'),
        ),
      ),
    );
  }
}
