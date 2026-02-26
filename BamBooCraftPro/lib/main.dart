import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/database/database_helper.dart';
import 'features/materials/presentation/providers/material_provider.dart';
import 'features/products/presentation/providers/product_provider.dart';
import 'features/workers/presentation/providers/worker_provider.dart';
import 'features/financials/presentation/providers/financial_provider.dart';
import 'features/materials/presentation/pages/inventory_screen.dart';
import 'features/products/presentation/pages/production_screen.dart';
import 'features/workers/presentation/pages/worker_list_screen.dart';
import 'features/financials/presentation/pages/salary_screen.dart';
import 'features/financials/presentation/pages/dashboard_screen.dart';
import 'features/reporting/presentation/pages/reporting_screen.dart';
import 'features/settings/presentation/pages/settings_screen.dart';

import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Theme Definitions
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green,
    primary: Colors.green[700],
    secondary: Colors.amber[700],
    surface: Colors.green[50]!,
    background: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.green[700],
    foregroundColor: Colors.white,
    centerTitle: true,
    titleTextStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    filled: true,
    fillColor: Colors.green[50],
    labelStyle: TextStyle(fontSize: 16, color: Colors.green[800]),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green[700],
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green,
    brightness: Brightness.dark,
    primary: Colors.green[400],
    secondary: Colors.amber[400],
    surface: const Color(0xFF1E3324),
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E3324),
    foregroundColor: Colors.white,
    centerTitle: true,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    filled: true,
    fillColor: const Color(0xFF2C4030),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green[600],
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  ),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize FFI for Desktop
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    try {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    } catch (e) {
      debugPrint('SQFLite FFI Init Failed: $e');
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MaterialProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => WorkerProvider()),
        ChangeNotifierProvider(create: (_) => FinancialProvider()),
      ],
      child: MaterialApp(
        title: 'BamBooCraft Pro',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const AppInitializer(),
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late Future<void> _initFuture;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    setState(() => _statusMessage = 'Initializing Database...');
    try {
      // Add a timeout to prevent infinite hanging
      await DatabaseHelper.instance.database.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Database initialization timed out (>10s). Check file permissions?');
        },
      );
      if (mounted) setState(() => _statusMessage = 'Database Ready!');
    } catch (e) {
      if (mounted) setState(() => _statusMessage = 'Error: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.green),
                  const SizedBox(height: 24),
                  Text(
                    _statusMessage ?? 'Starting...',
                    style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.red[50], // Light red background for visibility
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 64),
                    const SizedBox(height: 16),
                    const Text(
                      'Initialization Error',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${snapshot.error}',
                      style: const TextStyle(color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                       icon: const Icon(Icons.refresh),
                       label: const Text('Retry'),
                       style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                       onPressed: () {
                         setState(() {
                           _initFuture = _initializeDatabase();
                         });
                       },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const HomeScreen();
        }
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BamBooCraft Pro Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.inventory),
              label: const Text('Manage Inventory (Step 2)'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const InventoryScreen()),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.factory),
              label: const Text('Manage Production (Step 3)'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProductionScreen()),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text('Outsourcing (Step 4)'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WorkerListScreen()),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.monetization_on),
              label: const Text('Salary Payment (Step 5a)'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SalaryScreen()),
              ),
            ),
             const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.dashboard),
              label: const Text('Business Dashboard (Step 5b)'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
              ),
            ),
             const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.summarize),
              label: const Text('Reporting & Backup (Step 6)'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReportingScreen()),
              ),
            ),
             const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.settings),
              label: const Text('System Config (Step 7)'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
