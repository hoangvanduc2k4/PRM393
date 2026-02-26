import 'package:flutter/material.dart';
import '../../data/repositories/material_repository_impl.dart';
import '../../data/models/material_model.dart';

class MaterialProvider with ChangeNotifier {
  final MaterialRepository _repository = MaterialRepository();
  List<MaterialModel> _materials = [];

  List<MaterialModel> get materials => _materials;

  Future<void> loadMaterials() async {
    _materials = await _repository.getMaterials();
    notifyListeners();
  }

  Future<void> addMaterial(String name, String unit) async {
    await _repository.addMaterial(name, unit);
    await loadMaterials();
  }

  Future<void> importMaterial(String materialId, double quantity, double price, String source) async {
    await _repository.importMaterial(materialId: materialId, quantity: quantity, price: price, source: source);
    await loadMaterials();
  }
}
