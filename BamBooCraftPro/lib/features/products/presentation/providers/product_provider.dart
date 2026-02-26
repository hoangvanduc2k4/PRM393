import 'package:flutter/material.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/models/product_model.dart';
import '../../data/models/product_bom_model.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository _repository = ProductRepository();
  List<ProductModel> _products = [];
  List<ProductBomModel> _currentBOM = [];

  List<ProductModel> get products => _products;
  List<ProductBomModel> get currentBOM => _currentBOM;

  Future<void> loadProducts() async {
    _products = await _repository.getProducts();
    notifyListeners();
  }

  Future<void> addProduct(String name, double price, String description) async {
    await _repository.addProduct(name, price, description);
    await loadProducts();
  }

  Future<void> loadProductBOM(String productId) async {
    _currentBOM = await _repository.getProductBOM(productId);
    notifyListeners();
  }

  Future<void> addBOMItem(String productId, String materialId, double quantity) async {
    await _repository.addBOMItem(productId, materialId, quantity);
    await loadProductBOM(productId);
  }

  Future<void> produce(String productId, int quantity) async {
    await _repository.produce(productId: productId, quantity: quantity);
    notifyListeners();
  }
}
