import 'package:flutter/material.dart';

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TrangThoiKhoaBieu(),
  ),
);

class TrangThoiKhoaBieu extends StatefulWidget {
  const TrangThoiKhoaBieu({super.key});

  @override
  State<TrangThoiKhoaBieu> createState() => _TrangThoiKhoaBieuState();
}

class _TrangThoiKhoaBieuState extends State<TrangThoiKhoaBieu> {
  final List<String> namHocList = ["2025", "2026", "2027"];
  final List<String> tuanList = ["02/03 - 08/03", "09/03 - 15/03"];

  String namChon = "2026";
  String tuanChon = "02/03 - 08/03";

  final thuList = ["THỨ 2", "THỨ 3", "THỨ 4", "THỨ 5", "THỨ 6", "THỨ 7", "CN"];
  final ngayList = [
    "02/03",
    "03/03",
    "04/03",
    "05/03",
    "06/03",
    "07/03",
    "08/03",
  ];

  final gioTiet = [
    "Tiết 1\n07:00-07:45",
    "Tiết 2\n07:55-08:40",
    "Tiết 3\n08:50-09:35",
    "Tiết 4\n09:45-10:30",
    "Tiết 5\n13:00-13:45",
  ];

  final Map<String, String> giaoVien = {
    "Toán": "Thầy Bình",
    "Văn": "Cô Lan",
    "Anh": "Cô Mai",
    "Lý": "Thầy Tú",
    "Sử": "Cô Hoa",
    "Địa": "Thầy Nam",
    "Nhạc": "Cô Thúy",
  };

  final List<List<String>> monHoc = [
    ["Chào cờ", "Toán", "Anh", "Lý", "Sử"],
    ["Toán", "Toán", "Lý", "Địa", "Anh"],
    ["Anh", "Toán", "Sử", "Lý", "Địa"],
    ["Sử", "Anh", "Lý", "Toán", "-"],
    ["Địa", "Lý", "Nhạc", "Anh", "Sinh hoạt"],
    ["-", "-", "-", "-", "-"],
    ["-", "-", "-", "-", "-"],
  ];

  // --------- Ô Header có ComboBox ---------
  Widget oChonHeader(
    String label,
    Color labelColor,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isDense: true,
              style: const TextStyle(fontSize: 12, color: Colors.black),
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // --------- Ô text dữ liệu ---------
  Widget cell(String text, {bool bold = false, Color? color, Color? bg}) {
    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: color ?? Colors.black,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF5C88C4);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "THỜI KHÓA BIỂU",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Table(
        defaultColumnWidth: const FixedColumnWidth(110),
        columnWidths: const {0: FixedColumnWidth(180)},
        border: TableBorder.all(color: Colors.grey),
        children: [
          // --------- HÀNG 1: NĂM + THỨ ---------
          TableRow(
            decoration: const BoxDecoration(color: primaryColor),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: oChonHeader(
                  "NĂM",
                  Colors.red,
                  namChon,
                  namHocList,
                  (v) => setState(() => namChon = v!),
                ),
              ),
              ...thuList
                  .map((e) => cell(e, bold: true, color: Colors.white))
                  .toList(),
            ],
          ),

          // --------- HÀNG 2: TUẦN + NGÀY ---------
          TableRow(
            decoration: const BoxDecoration(color: primaryColor),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: oChonHeader(
                  "TUẦN",
                  const Color(0xFF37474F),
                  tuanChon,
                  tuanList,
                  (v) => setState(() => tuanChon = v!),
                ),
              ),
              ...ngayList.map((e) => cell(e, color: Colors.white)).toList(),
            ],
          ),

          // --------- CÁC HÀNG TIẾT HỌC ---------
          ...List.generate(gioTiet.length, (row) {
            return TableRow(
              children: [
                cell(gioTiet[row], bold: true),
                ...List.generate(7, (col) {
                  String mon = monHoc[col][row];
                  bool special = mon == "Chào cờ" || mon == "Sinh hoạt";

                  if (giaoVien.containsKey(mon)) {
                    mon = "$mon\n(${giaoVien[mon]})";
                  }

                  return cell(
                    mon,
                    bold: special,
                    color: special ? Colors.red : null,
                  );
                }),
              ],
            );
          }),
        ],
      ),
    );
  }
}
