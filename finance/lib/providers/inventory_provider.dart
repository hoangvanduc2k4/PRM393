import 'package:finance/core/db/database_helper.dart';
import 'package:finance/models/material_item.dart';
import 'package:finance/models/product_item.dart';
import 'package:flutter/foundation.dart';

class InventoryProvider with ChangeNotifier {
  // final DatabaseHelper _dbHelper = DatabaseHelper();

  List<MaterialItem> _materials = [
    MaterialItem(id: 1, name: 'Tre Gai Già', unit: 'tấn', quantity: 15.0, avgCost: 2500000), // 2.5tr/tấn
    MaterialItem(id: 2, name: 'Nứa Rừng', unit: 'tấn', quantity: 8.5, avgCost: 1800000),
    MaterialItem(id: 3, name: 'Mây Nếp', unit: 'tấn', quantity: 2.0, avgCost: 12000000),
    MaterialItem(id: 4, name: 'Sơn Ta (Phủ bóng)', unit: 'thùng', quantity: 20.0, avgCost: 500000),
    MaterialItem(id: 5, name: 'Dây Cước Buộc', unit: 'kg', quantity: 200.0, avgCost: 50000),
  ];

  List<ProductItem> _products = [
    ProductItem(id: 1, name: 'Ngựa Đan (Size Đại)', unit: 'con', quantity: 5, description: 'Cao 2m, trang trí sảnh', sellingPrice: 15000000),
    ProductItem(id: 2, name: 'Voi Chiến (Size Lớn)', unit: 'con', quantity: 3, description: 'Đầy đủ ngà, vòi', sellingPrice: 20000000),
    ProductItem(id: 3, name: 'Hổ Chúa', unit: 'con', quantity: 8, description: 'Vằn đen, dáng ngồi', sellingPrice: 8000000),
    ProductItem(id: 4, name: 'Trâu Nước', unit: 'con', quantity: 12, description: 'Mục đồng cưỡi trâu', sellingPrice: 5000000),
    ProductItem(id: 5, name: 'Rồng Thời Lý (Decor)', unit: 'bộ', quantity: 2, description: 'Dài 5m, uốn lượn', sellingPrice: 35000000),
    ProductItem(id: 6, name: 'Bàn Ghế Mây Tre', unit: 'bộ', quantity: 10, description: 'Bộ 4 ghế 1 bàn', sellingPrice: 4500000),
  ];

  List<MaterialItem> get materials => _materials;
  List<ProductItem> get products => _products;

  Future<void> loadInventory() async {
    // _materials = await _dbHelper.getMaterials();
    // _products = await _dbHelper.getProducts();
    notifyListeners();
  }

  // Material Actions
  Future<void> addMaterial(MaterialItem material) async {
    // await _dbHelper.insertMaterial(material);
    final newItem = MaterialItem(
        id: _materials.length + 1, 
        name: material.name, 
        unit: material.unit, 
        quantity: material.quantity, 
        avgCost: material.avgCost
    );
    _materials.add(newItem);
    await loadInventory();
  }

  Future<void> updateMaterial(MaterialItem material) async {
    // await _dbHelper.updateMaterial(material);
    final index = _materials.indexWhere((m) => m.id == material.id);
    if (index != -1) {
      _materials[index] = material;
      notifyListeners();
    }
  }

  // Product Actions
  Future<void> addProduct(ProductItem product) async {
    // await _dbHelper.insertProduct(product);
    final newItem = ProductItem(
      id: _products.length + 1,
      name: product.name,
      unit: product.unit,
      quantity: product.quantity,
      description: product.description,
      sellingPrice: product.sellingPrice,
    );
    _products.add(newItem);
    await loadInventory();
  }

  Future<void> updateProduct(ProductItem product) async {
    // await _dbHelper.updateProduct(product);
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      notifyListeners();
    }
  }
  
  // Method to update quantity directly (helper for transactions)
  Future<void> adjustMaterialQuantity(int id, double adjustment) async {
     try {
       final material = _materials.firstWhere((m) => m.id == id);
       final newQuantity = material.quantity + adjustment;
       final updatedMaterial = MaterialItem(
         id: material.id,
         name: material.name,
         unit: material.unit,
         quantity: newQuantity,
         avgCost: material.avgCost,
       );
       await updateMaterial(updatedMaterial);
     } catch (e) {
       print("Error updating material quantity: $e");
     }
  }

  Future<void> adjustProductQuantity(int id, int adjustment) async {
    try {
      final product = _products.firstWhere((p) => p.id == id);
      final newQuantity = product.quantity + adjustment;
      final updatedProduct = ProductItem(
        id: product.id,
        name: product.name,
        unit: product.unit,
        quantity: newQuantity,
        description: product.description,
        sellingPrice: product.sellingPrice,
      );
      await updateProduct(updatedProduct);
    } catch (e) {
      print("Error updating product quantity: $e");
    }
  }

  MaterialItem? getMaterialById(int id) {
    try {
      return _materials.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  ProductItem? getProductById(int id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
