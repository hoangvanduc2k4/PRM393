import 'package:flutter/material.dart';
import '../../../products/data/models/product_model.dart';
import '../../../products/data/repositories/product_repository_impl.dart';
import '../../data/repositories/settings_repository.dart';
import 'package:uuid/uuid.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('System Configuration'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.category), text: 'Products & BOM'),
              Tab(icon: Icon(Icons.straighten), text: 'Units'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ProductConfigTab(),
            UnitConfigTab(),
          ],
        ),
      ),
    );
  }
}

class ProductConfigTab extends StatefulWidget {
  const ProductConfigTab({super.key});

  @override
  State<ProductConfigTab> createState() => _ProductConfigTabState();
}

class _ProductConfigTabState extends State<ProductConfigTab> {
  final ProductRepository _productRepo = ProductRepository();
  List<ProductModel> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    final products = await _productRepo.getProducts();
    setState(() => _products = products);
  }

  void _showAddProductDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Product Name')),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Selling Price'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
               if (nameController.text.isNotEmpty) {
                  final price = double.tryParse(priceController.text) ?? 0.0;
                  final newProduct = ProductModel(
                    id: const Uuid().v4(),
                    name: nameController.text,
                    sellingPrice: price,
                    description: '',
                  );
                  // Ensure we have an addProduct method in repo or implement it.
                  // Checking existing repo... it has addProduct.
                  await _productRepo.addProduct(newProduct.name, newProduct.sellingPrice, newProduct.description ?? '');
                  _loadProducts();
                  Navigator.pop(ctx);
               }
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductDialog,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('Price: ${product.sellingPrice}'),
            trailing: const Icon(Icons.settings),
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailConfigScreen(product: product)));
            },
          );
        },
      ),
    );
  }
}

class ProductDetailConfigScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailConfigScreen({super.key, required this.product});

  @override
  State<ProductDetailConfigScreen> createState() => _ProductDetailConfigScreenState();
}

class _ProductDetailConfigScreenState extends State<ProductDetailConfigScreen> {
  final ProductRepository _productRepo = ProductRepository();
  List<Map<String, dynamic>> _parts = [];

  @override
  void initState() {
    super.initState();
    _loadParts();
  }

  void _loadParts() async {
    final parts = await _productRepo.getProductParts(widget.product.id);
    setState(() => _parts = parts);
  }

  void _addPart() {
    final partController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Outsourcing Part'),
        content: TextField(controller: partController, decoration: const InputDecoration(labelText: 'Part Name (e.g. Head)')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
             onPressed: () async {
                if (partController.text.isNotEmpty) {
                   await _productRepo.addProductPart(widget.product.id, partController.text);
                   _loadParts();
                   Navigator.pop(ctx);
                }
             }, 
             child: const Text('Add')
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Config: ${widget.product.name}')),
      body: Column(
        children: [
           const Padding(
             padding: EdgeInsets.all(8.0),
             child: Text('Outsourcing Parts Definition', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           ),
           Expanded(
             child: ListView.builder(
               itemCount: _parts.length,
               itemBuilder: (context, index) {
                 final part = _parts[index];
                 return ListTile(
                   title: Text(part['name']),
                   trailing: IconButton(
                     icon: const Icon(Icons.delete, color: Colors.red),
                     onPressed: () async {
                        await _productRepo.deleteProductPart(part['id']);
                        _loadParts();
                     },
                   ),
                 );
               },
             ),
           ),
           Padding(
             padding: const EdgeInsets.all(16.0),
             child: ElevatedButton.icon(onPressed: _addPart, icon: const Icon(Icons.add), label: const Text('Add Part')),
           ),
           const Divider(),
           // Placeholder for BOM Config (linking materials) - Implementation is similar
           const Padding(
             padding: EdgeInsets.all(8.0),
             child: Text('Note: To configure BOM (Materials), please use the Production Screen flow or implement similar list here.', style: TextStyle(fontStyle: FontStyle.italic)),
           )
        ],
      ),
    );
  }
}

class UnitConfigTab extends StatefulWidget {
  const UnitConfigTab({super.key});

  @override
  State<UnitConfigTab> createState() => _UnitConfigTabState();
}

class _UnitConfigTabState extends State<UnitConfigTab> {
  final SettingsRepository _settingsRepo = SettingsRepository();
  List<String> _units = [];

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  void _loadUnits() async {
    final units = await _settingsRepo.getUnits();
    setState(() => _units = units);
  }

  void _addUnit() {
     final controller = TextEditingController();
     showDialog(context: context, builder: (ctx) => AlertDialog(
        title: const Text('Add Unit'),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Unit Name')),
        actions: [
           TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
           TextButton(onPressed: () async {
              if (controller.text.isNotEmpty) {
                 await _settingsRepo.addUnit(controller.text);
                 _loadUnits();
                 Navigator.pop(ctx);
              }
           }, child: const Text('Add'))
        ],
     ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: _addUnit, child: const Icon(Icons.add)),
      body: ListView.builder(
        itemCount: _units.length,
        itemBuilder: (context, index) {
           return ListTile(
             title: Text(_units[index]),
             trailing: IconButton(
               icon: const Icon(Icons.delete, color: Colors.red),
               onPressed: () async {
                  await _settingsRepo.deleteUnit(_units[index]);
                  _loadUnits();
               },
             ),
           );
        },
      ),
    );
  }
}
