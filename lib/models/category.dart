import 'package:flutter/material.dart';

class Category {
  const Category({
    required this.id,
    required this.title,
    this.color = Colors.orange,//預設為橘色，lesson 155
  });
  final String id;
  final String title;
  final Color color;
}
