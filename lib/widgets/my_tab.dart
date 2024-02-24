import 'package:flutter/material.dart';

class MyTab extends StatelessWidget {
  const MyTab({super.key, required this.text});

  final String text;
  @override
  Widget build(BuildContext context) {
    return Tab(
        child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        color: Color.fromRGBO(0, 121, 107, 0.1),
      ),
      child: Text(text),
    ));
  }
}
