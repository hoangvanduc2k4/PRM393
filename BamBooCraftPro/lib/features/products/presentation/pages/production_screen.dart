import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../../../../core/utils/currency_formatter.dart';

class ProductionScreen extends StatefulWidget {
  const ProductionScreen({super.key});

  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
  String? _selectedProductId;
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  
  // Note: For real app, Material Selection for BOM should be dynamic. 
  // Here we assume BOM is set up elsewhere or we add a basic BOM setup dialog.
  // Given instructions: "10 con Ngựa tốn ...". Implicitly needs BOM setup.
  // I will add a simple "Add Product" dialog that creates a dummy BOM for testing.

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ProductProvider>(context, listen: false).loadProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Production Management')),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Product Selector
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Select Product to Produce'),
                  value: _selectedProductId,
                  items: provider.products.map((p) {
                    return DropdownMenuItem(value: p.id, child: Text(p.name));
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedProductId = val;
                    });
                  },
                ),
                const SizedBox(height: 16),
                
                // Quantity Input
                TextField(
                  controller: _quantityController,
                  decoration: const InputDecoration(labelText: 'Quantity (Units)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),

                ElevatedButton.icon(
                  onPressed: _produce, 
                  icon: const Icon(Icons.build),
                  label: const Text('PRODUCE NOW'),
                ),

                const SizedBox(height: 32),
                const Text('Available Products:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.products.length,
                    itemBuilder: (context, index) {
                      final product = provider.products[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Price: ${CurrencyFormatter.format(product.sellingPrice)}'),
                          leading: const Icon(Icons.shopping_bag, color: Colors.green),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      // Removed FloatingActionButton because Product Management is now in Settings
    );
  }

  void _produce() async {
    if (_selectedProductId == null) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a product!', style: TextStyle(fontSize: 16)), backgroundColor: Colors.red),
      );
      return;
    }
    if (_quantityController.text.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter quantity!', style: TextStyle(fontSize: 16)), backgroundColor: Colors.red),
      );
      return;
    }
    
    final qty = int.tryParse(_quantityController.text);
    if (qty == null || qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid quantity!', style: TextStyle(fontSize: 16)), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      await Provider.of<ProductProvider>(context, listen: false)
          .produce(_selectedProductId!, qty);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Production Successful!', style: TextStyle(fontSize: 16)), backgroundColor: Colors.green),
      );
      _quantityController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e', style: const TextStyle(fontSize: 16)), backgroundColor: Colors.red),
      );
    }
  }

  // Removed _showAddProductDialog as it is handled in SettingsScreen
}
