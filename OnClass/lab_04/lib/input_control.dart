import 'package:flutter/material.dart';

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});
  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  double _sliderVal = 50;
  bool _isSwitched = false;
  String _genre = 'None';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 2 – Input Contr...')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rating (Slider)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _sliderVal,
              max: 100,
              onChanged: (val) => setState(() => _sliderVal = val),
            ),
            Text('Current value: ${_sliderVal.toInt()}'),
            const SizedBox(height: 20),
            const Text(
              'Active (Switch)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text('Is movie active?'),
              value: _isSwitched,
              onChanged: (val) => setState(() => _isSwitched = val),
            ),
            const SizedBox(height: 20),
            const Text(
              'Genre (RadioListTile)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RadioListTile(
              title: const Text('Action'),
              value: 'Action',
              groupValue: _genre,
              onChanged: (val) => setState(() => _genre = val!),
            ),
            RadioListTile(
              title: const Text('Comedy'),
              value: 'Comedy',
              groupValue: _genre,
              onChanged: (val) => setState(() => _genre = val!),
            ),
            Text('Selected genre: $_genre'),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2030),
                ),
                child: const Text('Open Date Picker'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
