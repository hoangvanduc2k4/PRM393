import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../../../core/database/database_helper.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../workers/data/models/worker_model.dart';
import '../../../workers/data/models/outsourcing_order_model.dart';

class ReportingRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // 1. Generate Salary Slip PDF
  Future<void> generateSalarySlip({
    required WorkerModel worker,
    required List<OutsourcingOrderModel> orders,
    required DateTime month,
  }) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.robotoRegular(); // Use a font that supports Vietnamese if possible, otherwise subset might be needed.
    // Note: detailed vietnamese font support might require asset bundle. for now using roboto.

    final total = orders.fold(0.0, (sum, item) => sum + item.totalPayment);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(level: 0, child: pw.Text('PHIEU LUONG (SALARY SLIP)', style: pw.TextStyle(font: font, fontSize: 24, fontWeight: pw.FontWeight.bold))),
              pw.SizedBox(height: 20),
              pw.Text('Worker: ${worker.name}', style: pw.TextStyle(font: font, fontSize: 18)),
              pw.Text('Month: ${DateFormat('MM/yyyy').format(month)}', style: pw.TextStyle(font: font, fontSize: 16)),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                context: context,
                data: <List<String>>[
                  <String>['Date', 'Order ID', 'Status', 'Amount'],
                  ...orders.map((order) => [
                    DateFormat('dd/MM/yyyy').format(order.assignedDate),
                    order.id.substring(0, 4),
                    order.status,
                    CurrencyFormatter.format(order.totalPayment)
                  ]),
                ],
                headerStyle: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
                cellStyle: pw.TextStyle(font: font),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('TOTAL PAYMENT: ${CurrencyFormatter.format(total)}', style: pw.TextStyle(font: font, fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.red)),
                ],
              ),
              pw.SizedBox(height: 40),
              pw.Text('Signature ______________________', style: pw.TextStyle(font: font)),
            ],
          );
        },
      ),
    );

    // Save and Share
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/salary_slip_${worker.name}_${month.month}.pdf');
    await file.writeAsBytes(await pdf.save());
    
    await Share.shareXFiles([XFile(file.path)], text: 'Salary Slip for ${worker.name}');
  }

  // 2. Generate Revenue Excel
  Future<void> generateRevenueReport() async {
    final db = await _dbHelper.database;
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Report'];
    
    // Header
    sheetObject.appendRow([
      TextCellValue('Date'), 
      TextCellValue('Type'), 
      TextCellValue('Description'), 
      TextCellValue('Amount')
    ]);

    // Data
    final List<Map<String, dynamic>> transactions = await db.query('transactions', orderBy: 'date DESC');
    double totalRevenue = 0;
    double totalExpense = 0;

    for (var t in transactions) {
      double amount = (t['amount'] as num).toDouble();
      String type = t['type'];
      if (type == 'Revenue' || type == 'Sale') totalRevenue += amount;
      else totalExpense += amount;

      sheetObject.appendRow([
         TextCellValue(t['date'].toString().substring(0, 10)),
         TextCellValue(type),
         TextCellValue(t['description']),
         DoubleCellValue(amount),
      ]);
    }
    
    // Summary
    sheetObject.appendRow([TextCellValue('')]);
    sheetObject.appendRow([TextCellValue('SUMMARY')]);
    sheetObject.appendRow([TextCellValue('Total Revenue'), DoubleCellValue(totalRevenue)]);
    sheetObject.appendRow([TextCellValue('Total Expense'), DoubleCellValue(totalExpense)]);
    sheetObject.appendRow([TextCellValue('Net Profit'), DoubleCellValue(totalRevenue - totalExpense)]);

    // Save
    var fileBytes = excel.save();
    var directory = await getTemporaryDirectory(); // On Android/iOS use path_provider
    
    // For Windows, maybe Documents? But logic differs. let's use temp then share.
    // Or if platform is windows, use getApplicationDocumentsDirectory
    
    File(join(directory.path, 'revenue_report_${DateTime.now().millisecondsSinceEpoch}.xlsx'))
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);
      
    String filePath = join(directory.path, 'revenue_report.xlsx');
    File(filePath)..createSync(recursive: true)..writeAsBytesSync(fileBytes);
    
    await Share.shareXFiles([XFile(filePath)], text: 'Monthly Revenue Report');
  }

  // 3. Backup Database
  Future<void> backupDatabase() async {
    final dbFolder = await getDatabasesPath();
    final dbPath = join(dbFolder, 'bamboocraft.db');
    
    final dbFile = File(dbPath);
    if (await dbFile.exists()) {
        try {
          // On Mobile: Share the file
          // On Desktop: Copy to Downloads
          if (Platform.isWindows) {
              // Just simpler to share for now or copy to user Documents
              final docsDir = await getApplicationDocumentsDirectory();
              final backupPath = join(docsDir.path, 'BamBooCraft_Backup_${DateTime.now().millisecondsSinceEpoch}.db');
              await dbFile.copy(backupPath);
              // Also try to open the folder? 
              // For now ensuring it is saved is enough.
              // Let's use Share as it is universal feedback
               await Share.shareXFiles([XFile(dbPath)], text: 'Database Backup');
          } else {
              await Share.shareXFiles([XFile(dbPath)], text: 'Database Backup');
          }
        } catch (e) {
            // ignore
        }
    }
  }
}
