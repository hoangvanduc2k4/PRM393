import 'package:cloud_firestore/cloud_firestore.dart';
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
  final List<String> joinedChildIds;

  ClubModel({
    required this.id,
    required this.name,
    required this.category,
    required this.memberCount,
    required this.isJoined,
    required this.icon,
    required this.color,
    required this.joinedChildIds,
  });

  factory ClubModel.fromFirestore(DocumentSnapshot doc, String currentChildId) {
    Map data = doc.data() as Map<String, dynamic>;
    
    // Helper to map category to icon & color
    IconData getIcon(String cat) {
      switch (cat) {
        case 'Học thuật': return Iconsax.book;
        case 'Nghệ thuật': return Iconsax.music;
        case 'Thể thao': return Iconsax.activity;
        case 'Truyền thông': return Iconsax.camera;
        case 'Khoa học': return Iconsax.programming_arrows;
        default: return Iconsax.category;
      }
    }

    Color getColor(String cat) {
      switch (cat) {
        case 'Học thuật': return Colors.blue;
        case 'Nghệ thuật': return Colors.purple;
        case 'Thể thao': return Colors.orange;
        case 'Truyền thông': return Colors.teal;
        case 'Khoa học': return Colors.red;
        default: return Colors.grey;
      }
    }

    List<String> joined = List<String>.from(data['joinedChildIds'] ?? []);

    return ClubModel(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? 'Khác',
      memberCount: data['memberCount'] ?? 0,
      isJoined: joined.contains(currentChildId),
      joinedChildIds: joined,
      icon: getIcon(data['category'] ?? ''),
      color: getColor(data['category'] ?? ''),
    );
  }
}

