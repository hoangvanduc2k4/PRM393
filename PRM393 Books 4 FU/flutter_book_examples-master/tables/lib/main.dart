import 'package:flutter/material.dart';

void main() => runApp(const TableApp());

class TableApp extends StatelessWidget {
  const TableApp({super.key});

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
  const HomeWidget({super.key}); // FIX tại đây

  @override
  Widget build(BuildContext context) {
    const TableRow tableRow = TableRow(
      children: [
        Text("aaaaaaaaaaaaaaaaaaaaa", overflow: TextOverflow.fade),
        Text("bbbbbbbbbbbbbbbbbbbbb", overflow: TextOverflow.fade),
        Text("ccccccccccccccccccccc", overflow: TextOverflow.ellipsis),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Table")),
      body: Table(
        children: const [
          tableRow,
          tableRow,
          tableRow,
          tableRow,
          tableRow,
          tableRow,
          tableRow,
          tableRow,
          tableRow,
        ],
        columnWidths: {
          0: FlexColumnWidth(0.1),
          1: FlexColumnWidth(0.3),
          2: FlexColumnWidth(0.6),
        },
        border: TableBorder.all(),
      ),
    );
  }
}
