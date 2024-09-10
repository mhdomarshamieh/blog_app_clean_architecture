import 'package:flutter/material.dart';

class BlogEditor extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const BlogEditor({
    super.key,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
      ),
      controller: controller,
      maxLines: null,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$hintText is missing';
        }
        return null;
      },
    );
  }
}
