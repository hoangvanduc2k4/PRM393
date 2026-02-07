import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeWidget(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key, required this.title});
  final String title;

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _counter = 0;

  Future<bool> _showConfirmDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm'),
              content: const Text(
                'Are you sure you want to increment the counter?',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('No'),
                ),
              ],
            );
          },
        ) ??
        false; // nếu user bấm ra ngoài → false
  }

  void _incrementCounter() {
    _showConfirmDialog().then((result) {
      if (result == true) {
        setState(() {
          _counter++;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text('$_counter', style: Theme.of(context).textTheme.displayMedium),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
