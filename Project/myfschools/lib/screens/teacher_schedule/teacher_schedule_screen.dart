import 'package:flutter/material.dart';
import '../../controllers/teacher_schedule_controller.dart';

class TeacherScheduleScreen extends StatefulWidget {
  final String teacherEmail;
  const TeacherScheduleScreen({super.key, required this.teacherEmail});

  @override
  State<TeacherScheduleScreen> createState() => _TeacherScheduleScreenState();
}

class _TeacherScheduleScreenState extends State<TeacherScheduleScreen> {
  final TeacherScheduleController _controller = TeacherScheduleController();

  final thuList = ["THỨ 2", "THỨ 3", "THỨ 4", "THỨ 5", "THỨ 6", "THỨ 7", "CN"];
  final ngayList = [
    "10/03", // Mon
    "11/03", // Tue 
    "12/03", // Wed
    "13/03", // Thu
    "14/03", // Fri
    "15/03", // Sat
    "16/03", // Sun
  ];

  final gioTiet = [
    "Tiết 1\n07:00-07:45",
    "Tiết 2\n07:55-08:40",
    "Tiết 3\n08:50-09:35",
    "Tiết 4\n09:45-10:30",
    "Tiết 5\n13:00-13:45",
  ];

  @override
  void initState() {
    super.initState();
    _controller.fetchTeacherSchedule(widget.teacherEmail);
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          "LỊCH DẠY CỦA TÔI",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _controller.isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _controller.error != null
              ? Center(child: Text(_controller.error!))
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        defaultColumnWidth: const FixedColumnWidth(100),
                        columnWidths: const {0: FixedColumnWidth(160)},
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
                                  _controller.namChon,
                                  _controller.namHocList,
                                  (v) => _controller.updateNamChon(v!),
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
                                  _controller.tuanChon,
                                  _controller.tuanList,
                                  (v) => _controller.updateTuanChon(v!),
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
                                  String detail = _controller.monHocMatrix[col][row];
                                  bool isClass = detail != "-";

                                  return cell(
                                    detail,
                                    bold: isClass,
                                    color: isClass ? Colors.blue[900] : null,
                                  );
                                }),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
