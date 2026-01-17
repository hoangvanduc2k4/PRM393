class Vehicle {
  String model;
  Vehicle.named(this.model);

  void describe() {
    print("Vehicle $model running");
  }
}
