import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // thêm super.key

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title}); // sửa ở đây

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextStyle textStyle1 = const TextStyle(
    color: Colors.blue,
    fontSize: 40.0,
    fontWeight: FontWeight.w200,
  );
  TextStyle textStyle2 = const TextStyle(
    color: Colors.green,
    fontSize: 40.0,
    fontWeight: FontWeight.w600,
  );

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = _counter % 2 == 0 ? textStyle1 : textStyle2;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedDefaultTextStyle(
              duration: const Duration(seconds: 1),
              style: textStyle,
              child: const Text('You have pushed', textAlign: TextAlign.center),
            ),
            AnimatedDefaultTextStyle(
              duration: const Duration(seconds: 1),
              style: textStyle,
              child: const Text('the button this', textAlign: TextAlign.center),
            ),
            AnimatedDefaultTextStyle(
              duration: const Duration(seconds: 1),
              style: textStyle,
              child: const Text('many times:', textAlign: TextAlign.center),
            ),
            AnimatedDefaultTextStyle(
              duration: const Duration(seconds: 1),
              style: textStyle,
              child: Text('$_counter', textAlign: TextAlign.center),
            ),
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
