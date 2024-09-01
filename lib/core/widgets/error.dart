import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String title;
  const ErrorScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title),
    );
  }
}
