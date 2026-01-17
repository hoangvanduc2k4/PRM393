import 'package:flutter/material.dart';

class LayoutBasicsDemo extends StatelessWidget {
  const LayoutBasicsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final movies = ['Avatar', 'Inception', 'Interstellar', 'Joker'];
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 3 – Layout De...')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Now Playing',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(movies[index][0])),
                    title: Text(movies[index]),
                    subtitle: const Text('Sample description'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
