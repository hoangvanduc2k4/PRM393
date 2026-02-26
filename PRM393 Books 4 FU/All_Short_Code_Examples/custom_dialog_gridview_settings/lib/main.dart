import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const GridViewApp());

// =============================
// GRID OPTIONS MODEL
// =============================
class GridOptions {
  int crossAxisCountPortrait;
  int crossAxisCountLandscape;
  double childAspectRatio;
  double padding;
  double spacing;

  GridOptions(
    this.crossAxisCountPortrait,
    this.crossAxisCountLandscape,
    this.childAspectRatio,
    this.padding,
    this.spacing,
  );

  GridOptions.copyOf(GridOptions other)
    : crossAxisCountPortrait = other.crossAxisCountPortrait,
      crossAxisCountLandscape = other.crossAxisCountLandscape,
      childAspectRatio = other.childAspectRatio,
      padding = other.padding,
      spacing = other.spacing;

  @override
  String toString() {
    return 'GridOptions{portrait: $crossAxisCountPortrait, landscape: $crossAxisCountLandscape, aspect: $childAspectRatio, padding: $padding, spacing: $spacing}';
  }
}

// =============================
// APP ROOT
// =============================
class GridViewApp extends StatelessWidget {
  const GridViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Grid Demo",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeWidget(),
    );
  }
}

// =============================
// DIALOG TÙY CHỌN
// =============================
class CustomDialogWidget extends StatefulWidget {
  final GridOptions gridOptions;
  const CustomDialogWidget(this.gridOptions, {super.key});

  @override
  State<CustomDialogWidget> createState() =>
      _CustomDialogWidgetState(GridOptions.copyOf(gridOptions));
}

class _CustomDialogWidgetState extends State<CustomDialogWidget> {
  GridOptions gridOptions;
  _CustomDialogWidgetState(this.gridOptions);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      width: 260,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            "Grid Options",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          // Portrait Count
          _buildRow(
            "Cross Axis Portrait",
            DropdownButton<int>(
              value: gridOptions.crossAxisCountPortrait,
              items: [2, 3, 4, 5, 6]
                  .map((e) => DropdownMenuItem(value: e, child: Text("$e")))
                  .toList(),
              onChanged: (v) => setState(() {
                gridOptions.crossAxisCountPortrait = v!;
              }),
            ),
          ),

          // Landscape Count
          _buildRow(
            "Cross Axis Landscape",
            DropdownButton<int>(
              value: gridOptions.crossAxisCountLandscape,
              items: [2, 3, 4, 5, 6]
                  .map((e) => DropdownMenuItem(value: e, child: Text("$e")))
                  .toList(),
              onChanged: (v) => setState(() {
                gridOptions.crossAxisCountLandscape = v!;
              }),
            ),
          ),

          // Aspect Ratio
          _buildRow(
            "Aspect Ratio",
            DropdownButton<double>(
              value: gridOptions.childAspectRatio,
              items: [1.0, 1.5, 2.0, 2.5]
                  .map((e) => DropdownMenuItem(value: e, child: Text("$e")))
                  .toList(),
              onChanged: (v) => setState(() {
                gridOptions.childAspectRatio = v!;
              }),
            ),
          ),

          // Padding
          _buildRow(
            "Padding",
            DropdownButton<double>(
              value: gridOptions.padding,
              items: [1, 2, 4, 8, 16, 32].map((e) {
                return DropdownMenuItem<double>(
                  value: e.toDouble(),
                  child: Text(e.toString()),
                );
              }).toList(),
              onChanged: (v) => setState(() {
                gridOptions.padding = v!;
              }),
            ),
          ),

          // Spacing
          _buildRow(
            "Spacing",
            DropdownButton<double>(
              value: gridOptions.spacing,
              items: [1, 2, 4, 8, 16, 32].map((e) {
                return DropdownMenuItem<double>(
                  value: e.toDouble(),
                  child: Text(e.toString()),
                );
              }).toList(),
              onChanged: (v) => setState(() {
                gridOptions.spacing = v!;
              }),
            ),
          ),

          // Apply Button
          ElevatedButton(
            onPressed: () => Navigator.pop(context, gridOptions),
            child: const Text("Apply"),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, Widget control) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Text(label),
        const Spacer(),
        control,
        const Spacer(),
      ],
    );
  }
}

// =============================
// HOME SCREEN
// =============================
class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late List<Widget> kittenTiles;
  GridOptions gridOptions = GridOptions(2, 3, 1.0, 4.0, 4.0);

  _HomeWidgetState() {
    kittenTiles = [];

    for (int size = 200; size < 1000; size += 100) {
      final url = "https://placekitten.com/200/$size";

      kittenTiles.add(
        GridTile(
          header: GridTileBar(
            title: const Text(
              "Cats",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.black54,
          ),
          footer: const GridTileBar(
            title: Text(
              "How cute",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          child: Image.network(url, fit: BoxFit.cover),
        ),
      );
    }
  }

  Future<void> _showGridOptionsDialog() async {
    final result = await showDialog<GridOptions>(
      context: context,
      builder: (_) => Dialog(child: CustomDialogWidget(gridOptions)),
    );

    if (result != null) {
      setState(() => gridOptions = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GridView")),

      body: OrientationBuilder(
        builder: (context, orientation) {
          return GridView.count(
            crossAxisCount: (orientation == Orientation.portrait)
                ? gridOptions.crossAxisCountPortrait
                : gridOptions.crossAxisCountLandscape,
            childAspectRatio: gridOptions.childAspectRatio,
            padding: EdgeInsets.all(gridOptions.padding),
            crossAxisSpacing: gridOptions.spacing,
            mainAxisSpacing: gridOptions.spacing,
            children: kittenTiles,
          );
        },
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(gridOptions.toString()),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showGridOptionsDialog,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
