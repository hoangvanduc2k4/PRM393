import 'package:demo_dart/vehical_model.dart';

class Bike extends Vehicle {
  Bike(String model) : super.named(model);

  @override
  void describe() {
    print("Bike $model pedaling");
  }
}
