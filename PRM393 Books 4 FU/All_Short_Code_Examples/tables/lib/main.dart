import 'package:flutter/material.dart';

void main() => runApp(TableApp());

class TableApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeWidget(),
    );
  }
}

class HomeWidget extends StatelessWidget {
  HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TableRow tableRow = TableRow(
      children: const [
        Text("aaaaaaaaaaaaaaaaaaaaa", overflow: TextOverflow.fade),
        Text("bbbbbbbbbbbbbbbbbbbbb", overflow: TextOverflow.fade),
        Text("ccccccccccccccccccccc", overflow: TextOverflow.ellipsis),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text("Table")),
      body: Table(
        children: [
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
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(0.1),
          1: FlexColumnWidth(0.3),
          2: FlexColumnWidth(0.6),
        },
        border: TableBorder.all(),
      ),
    );
  }
}
