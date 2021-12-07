import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  const Category(this.title, {Key? key}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      tileColor: Colors.black12,
    );
  }
}
