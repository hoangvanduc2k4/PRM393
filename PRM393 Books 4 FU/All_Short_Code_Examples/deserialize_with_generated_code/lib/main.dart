import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'main.g.dart';

// ---------------------- MODEL ----------------------

@JsonSerializable()
class Person {
  final String name;

  @JsonKey(name: "addr1")
  final String addressLine1;

  @JsonKey(name: "city")
  final String addressCity;

  @JsonKey(name: "state")
  final String addressState;

  Person(this.name, this.addressLine1, this.addressCity, this.addressState);

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);

  @override
  String toString() =>
      "Person{name: $name, addressLine1: $addressLine1, addressCity: $addressCity, addressState: $addressState}";
}

// ---------------------- APP ----------------------

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final _jsonTextController = TextEditingController();
  Person? _person;
  String? _error;

  _HomeWidgetState() {
    final String person =
        "{\"name\":\"Tracy Brown\", \"addr1\":\"9625 Roberts Avenue\", \"city\":\"Birmingham\", \"state\":\"AL\"}";

    _jsonTextController.text = person;
  }

  _convertJsonToPerson() {
    setState(() {
      try {
        _error = null;

        final String jsonText = _jsonTextController.text;
        var decoded = json.decode(jsonText); // text -> map

        _person = Person.fromJson(decoded);
      } catch (e) {
        _error = e.toString();
        _person = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Deserialization")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter JSON",
              ),
              controller: _jsonTextController,
              maxLines: 8,
            ),
            SizedBox(height: 10),
            if (_error != null)
              Text("Error:\n${_error!}", style: TextStyle(color: Colors.red)),
            SizedBox(height: 10),
            Text(
              _person == null
                  ? "Person is null"
                  : "Converted Person:\n\n${_person!}",
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _convertJsonToPerson,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
