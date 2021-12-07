import 'package:flutter/material.dart';

class CountTile extends StatelessWidget {
  const CountTile({required this.label, required this.count, Key? key})
      : super(key: key);

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(label), trailing: Text('$count'));
  }
}
