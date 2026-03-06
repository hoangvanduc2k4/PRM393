class ChildModel {
  final String childId;
  final String childName;
  final String className;
  final String avatarUrl;

  ChildModel({
    required this.childId,
    required this.childName,
    required this.className,
    required this.avatarUrl,
  });

  factory ChildModel.fromMap(Map<String, dynamic> data) {
    return ChildModel(
      childId: data['childId'] ?? 'N/A',
      childName: data['childName'] ?? 'Không có tên',
      className: data['className'] ?? 'N/A',
      avatarUrl: data['avatarUrl'] ?? '',
    );
  }
}
