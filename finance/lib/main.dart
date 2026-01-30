import 'dart:io';
import 'package:finance/core/constants/app_theme.dart';
import 'package:finance/providers/inventory_provider.dart';
import 'package:finance/providers/transaction_provider.dart';
import 'package:finance/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // if (Platform.isWindows || Platform.isLinux) {
  //   // Initialize FFI
  //   sqfliteFfiInit();
  //   // Change the default factory
  //   databaseFactory = databaseFactoryFfi;
  // }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InventoryProvider()..loadInventory()),
        ChangeNotifierProxyProvider<InventoryProvider, TransactionProvider>(
          create: (context) => TransactionProvider(Provider.of<InventoryProvider>(context, listen: false)),
          update: (context, inventory, transaction) => TransactionProvider(inventory)..loadData(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VIP Finance Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const DashboardScreen(),
    );
  }
}
