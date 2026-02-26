void main() {
  Car car = Car("BMW", "M3");
  print(car.getBadge());
  Car car2 = new Car("BMW", "M3");
  print(car2.getBadge());
}

class Car {
  String _make;
  String _model;
  Car(this._make, this._model) {}
  String getBadge() {
    return _make + " - " + _model;
  }
}
