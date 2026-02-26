import 'package:flutter/material.dart';
import '../../data/repositories/worker_repository.dart';
import '../../data/models/worker_model.dart';
import '../../data/models/outsourcing_order_model.dart';

class WorkerProvider with ChangeNotifier {
  final WorkerRepository _repository = WorkerRepository();
  List<WorkerModel> _workers = [];
  Map<String, List<OutsourcingOrderModel>> _workerOrders = {};

  List<WorkerModel> get workers => _workers;

  Future<void> loadWorkers() async {
    _workers = await _repository.getWorkers();
    notifyListeners();
  }

  Future<void> addWorker(String name, String phone, String specialization) async {
    await _repository.addWorker(name, phone, specialization);
    await loadWorkers();
  }

  Future<List<OutsourcingOrderModel>> getWorkerOrders(String workerId) async {
    if (_workerOrders.containsKey(workerId)) {
      // Optional: return cached or refresh. Let's refresh.
    }
    final orders = await _repository.getWorkerOrders(workerId);
    _workerOrders[workerId] = orders;
    notifyListeners();
    return orders;
  }

  Future<void> assignWork(String workerId, String partName, int qty) async {
    await _repository.assignWork(workerId: workerId, partName: partName, quantityAssigned: qty);
    await getWorkerOrders(workerId); // Refresh orders
  }

  Future<void> completeWork(String orderId, int pairsReceived, double price, String workerId) async {
    await _repository.completeWork(orderId: orderId, pairsReceived: pairsReceived, pricePerPair: price);
    await getWorkerOrders(workerId); // Refresh
  }
  
  Future<OutsourcingItemModel?> getOrderItem(String orderId) {
      return _repository.getOrderItem(orderId);
  }
}
