import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ClubModel {
  final String id;
  final String name;
  final String category;
  int memberCount;
  bool isJoined;
  final IconData icon;
  final Color color;

  ClubModel({
    required this.id,
    required this.name,
    required this.category,
    required this.memberCount,
    required this.isJoined,
    required this.icon,
    required this.color,
  });

  static IconData _getIcon(String cat) {
    switch (cat) {
      case 'Học thuật':
        return Iconsax.book;
      case 'Nghệ thuật':
        return Iconsax.music;
      case 'Thể thao':
        return Iconsax.activity;
      case 'Truyền thông':
        return Iconsax.camera;
      case 'Khoa học':
        return Iconsax.programming_arrows;
      default:
        return Iconsax.category;
    }
  }

  static Color _getColor(String cat) {
    switch (cat) {
      case 'Học thuật':
        return Colors.blue;
      case 'Nghệ thuật':
        return Colors.purple;
      case 'Thể thao':
        return Colors.orange;
      case 'Truyền thông':
        return Colors.teal;
      case 'Khoa học':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  factory ClubModel.fromApi(Map<String, dynamic> data) {
    final category = data['category'] ?? 'Khác';
    return ClubModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      category: category,
      memberCount: data['memberCount'] ?? 0,
      isJoined: false, // Được set riêng sau khi so sánh với danh sách joined
      icon: _getIcon(category),
      color: _getColor(category),
    );
  }

  ClubModel copyWith({bool? isJoined}) {
    return ClubModel(
      id: id,
      name: name,
      category: category,
      memberCount: memberCount,
      isJoined: isJoined ?? this.isJoined,
      icon: icon,
      color: color,
    );
  }
}
