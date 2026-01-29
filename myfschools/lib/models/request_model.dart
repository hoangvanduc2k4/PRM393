class RequestModel {
  final String id;
  final String title;
  final String type; // "Xin nghỉ học", "Xin đến muộn", "Bảo lưu"
  final DateTime date;
  final String status; // "Chờ duyệt", "Đã duyệt", "Từ chối"
  final String reason;

  RequestModel({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.status,
    required this.reason,
  });

  static List<RequestModel> getMockData() {
    final now = DateTime.now();
    return [
      RequestModel(
        id: 'REQ001',
        title: 'Xin nghỉ học vì lý do sức khỏe',
        type: 'Xin nghỉ học',
        date: now.subtract(const Duration(days: 2)),
        status: 'Đã duyệt',
        reason: 'Em bị sốt cao không thể đến lớp.',
      ),
      RequestModel(
        id: 'REQ002',
        title: 'Xin đến muộn tiết 1',
        type: 'Xin đến muộn',
        date: now.subtract(const Duration(days: 0)), // Today
        status: 'Chờ duyệt',
        reason: 'Xe hỏng dọc đường.',
      ),
      RequestModel(
        id: 'REQ003',
        title: 'Xin nghỉ học đi khám bệnh',
        type: 'Xin nghỉ học',
        date: now.subtract(const Duration(days: 5)),
        status: 'Từ chối',
        reason: 'Lý do không chính đáng (thiếu giấy tờ).',
      ),
    ];
  }
}
