import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu(this.title, {required this.onTap, Key? key}) : super(key: key);

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: OutlinedButton(
          child: Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          onPressed: onTap),
    );
  }
}
