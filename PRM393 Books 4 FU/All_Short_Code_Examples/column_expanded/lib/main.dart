import 'package:flutter/material.dart';

void main() => runApp(const ColumnSpacedEvenly());

class ColumnSpacedEvenly extends StatelessWidget {
  const ColumnSpacedEvenly({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeWidget(),
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final RawMaterialButton redButton = RawMaterialButton(
      onPressed: () {},
      elevation: 2.0,
      fillColor: Colors.red,
    );

    final RawMaterialButton greenButton = RawMaterialButton(
      onPressed: () {},
      elevation: 2.0,
      fillColor: Colors.green,
    );

    final RawMaterialButton blueButton = RawMaterialButton(
      onPressed: () {},
      elevation: 2.0,
      fillColor: Colors.blue,
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Column")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(child: redButton),
            Expanded(child: greenButton),
            Expanded(child: blueButton),
          ],
        ),
      ),
    );
  }
}
