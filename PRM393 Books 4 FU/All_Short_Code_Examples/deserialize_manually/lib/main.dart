import 'package:flutter/material.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class Person {
  final String name;
  final String addressLine1;
  final String addressCity;
  final String addressState;
  final List<Person> children;

  const Person(
    this.name,
    this.addressLine1,
    this.addressCity,
    this.addressState,
    this.children,
  );

  factory Person.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw FormatException("Null JSON.");
    }

    // children có thể null
    List<dynamic> decodedChildren = json['children'] ?? [];
    List<Person> children = decodedChildren
        .map((child) => Person.fromJson(child))
        .toList();

    return Person(
      json['name'] ?? "",
      json['addr1'] ?? "",
      json['city'] ?? "",
      json['state'] ?? "",
      children,
    );
  }

  @override
  String toString() {
    return 'Person{name: $name, addressLine1: $addressLine1, '
        'addressCity: $addressCity, addressState: $addressState, '
        'children: $children}';
  }
}

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
  HomeWidget({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final _jsonTextController = TextEditingController();
  Person? _person;
  String? _error;

  _HomeWidgetState() {
    final String grandchild =
        "{\"name\":\"Tracy Brown\", \"addr1\":\"9625 Roberts Avenue\","
        "\"city\":\"Birmingham\", \"state\":\"AL\", \"children\":[]}";

    final String adultFather =
        "{\"name\":\"John Brown\", \"addr1\":\"9625 Roberts Avenue\","
        "\"city\":\"Birmingham\", \"state\":\"AL\", \"children\":[$grandchild]}";

    final String adultNoChildren =
        "{\"name\":\"Jill Jones\", \"addr1\":\"100 East Road\","
        "\"city\":\"Ocala\", \"state\":\"FL\", \"children\":[]}";

    final String grandfather =
        "{\"name\":\"John Brown\", \"addr1\":\"9621 Roberts Avenue\","
        "\"city\":\"Birmingham\", \"state\":\"AL\", \"children\":[$adultFather,$adultNoChildren]}";

    _jsonTextController.text = grandfather;
  }

  TextFormField _createJsonTextFormField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the json.';
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Json',
        labelText: 'Enter the json for a person.',
      ),
      controller: _jsonTextController,
      autofocus: true,
      maxLines: 8,
      keyboardType: TextInputType.multiline,
    );
  }

  _convertJsonToPerson() {
    _error = null;
    _person = null;
    setState(() {
      try {
        final String jsonText = _jsonTextController.text;
        debugPrint("JSON TEXT: ${jsonText}");

        var decoded = json.decode(jsonText);
        debugPrint("DECODED: type: ${decoded.runtimeType} value: ${decoded}");

        _person = Person.fromJson(decoded);
        debugPrint("PERSON OBJECT: ${_person}");
      } catch (e) {
        debugPrint("ERROR: $e");
        _error = e.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recursive Deserialization")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              _createJsonTextFormField(),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  _error == null ? '' : 'Error:\n\n$_error',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  _person == null
                      ? 'Person is null'
                      : 'Converted Person object:\n\n$_person',
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _convertJsonToPerson,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
