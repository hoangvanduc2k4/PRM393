
class FormModel {
  final String id;
  final String title;
  final String type;
  final String date;
  final String reason;
  final String status; // Approved, Pending, Rejected

  FormModel({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.reason,
    required this.status,
  });
}
