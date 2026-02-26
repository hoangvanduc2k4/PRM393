import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/material_provider.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<MaterialProvider>(context, listen: false).loadMaterials());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Management')),
      body: Consumer<MaterialProvider>(
        builder: (context, provider, child) {
          if (provider.materials.isEmpty) {
            return const Center(child: Text('No materials found. Add one!'));
          }
          return ListView.builder(
            itemCount: provider.materials.length,
            itemBuilder: (context, index) {
              final material = provider.materials[index];
              return Card(
                child: ListTile(
                  title: Text(material.name),
                  subtitle: Text('Unit: ${material.unit}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${material.quantityAvailable} ${material.unit}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () => _showImportDialog(context, material.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMaterialDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddMaterialDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController();
        final unitController = TextEditingController();
        return AlertDialog(
          title: const Text('Add New Material'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name')),
              TextField(
                  controller: unitController,
                  decoration: const InputDecoration(labelText: 'Unit (kg, ton...)')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async { // Added async here
                if (nameController.text.isNotEmpty &&
                    unitController.text.isNotEmpty) {
                  // The original instruction had `MaterialRepositoryImpl` and `addImport`
                  // which are not defined in this context and would cause errors.
                  // It also had `qty` and `cost` which are not available here.
                  // Assuming the intent was to add `await` and `context.mounted`
                  // to the existing `addMaterial` call.
                  await Provider.of<MaterialProvider>(context, listen: false)
                      .addMaterial(nameController.text, unitController.text);
                  if (context.mounted) Navigator.pop(context); // Corrected typo from `ctx);ontext)`
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showImportDialog(BuildContext context, String materialId) {
    showDialog(
      context: context,
      builder: (context) {
        final qtyController = TextEditingController();
        final priceController = TextEditingController();
        final sourceController = TextEditingController();
        return AlertDialog(
            title: const Text('Import Material'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(controller: qtyController, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Unit Price'), keyboardType: TextInputType.number),
              TextField(controller: sourceController, decoration: const InputDecoration(labelText: 'Source')),
            ]),
            actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                TextButton(onPressed: () {
                    final qty = double.tryParse(qtyController.text);
                    final price = double.tryParse(priceController.text);
                    if (qty != null && price != null) {
                        Provider.of<MaterialProvider>(context, listen: false).importMaterial(materialId, qty, price, sourceController.text);
                        Navigator.pop(context);
                    }
                }, child: const Text('Import'))
            ]
        );
      },
    );
  }
}
