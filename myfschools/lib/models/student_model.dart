class StudentModel {
  final String id;
  final String name;
  final String email;
  final String major;
  final String avatarUrl;

  StudentModel({
    required this.id,
    required this.name,
    required this.email,
    required this.major,
    required this.avatarUrl,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      major: json['major'],
      avatarUrl: json['avatarUrl'],
    );
  }

  static StudentModel getMockData() {
    return StudentModel(
      id: 'HE150001',
      name: 'Nguyen Van A',
      email: 'anvhe150001@fpt.edu.vn',
      major: 'Software Engineering',
      avatarUrl: 'https://via.placeholder.com/150',
    );
  }
}
