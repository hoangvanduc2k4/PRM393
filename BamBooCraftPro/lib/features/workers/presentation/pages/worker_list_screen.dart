import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/worker_provider.dart';
import 'worker_detail_screen.dart';

class WorkerListScreen extends StatefulWidget {
  const WorkerListScreen({super.key});

  @override
  State<WorkerListScreen> createState() => _WorkerListScreenState();
}

class _WorkerListScreenState extends State<WorkerListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<WorkerProvider>(context, listen: false).loadWorkers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Worker Management')),
      body: Consumer<WorkerProvider>(
        builder: (context, provider, child) {
          if (provider.workers.isEmpty) {
            return const Center(child: Text('No workers yet. Add one!'));
          }
          return ListView.builder(
            itemCount: provider.workers.length,
            itemBuilder: (context, index) {
              final worker = provider.workers[index];
              return ListTile(
                title: Text(worker.name),
                subtitle: Text('${worker.specialization ?? "General"} - ${worker.phone}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkerDetailScreen(workerId: worker.id, workerName: worker.name),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddWorkerDialog,
        child: const Icon(Icons.person_add),
      ),
    );
  }

  void _showAddWorkerDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final specController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Worker'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone')),
            TextField(controller: specController, decoration: const InputDecoration(labelText: 'Specialization')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                Provider.of<WorkerProvider>(context, listen: false).addWorker(
                  nameController.text,
                  phoneController.text,
                  specController.text,
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }
}
