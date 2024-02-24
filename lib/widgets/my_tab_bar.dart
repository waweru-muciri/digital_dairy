import 'package:flutter/material.dart';

class MyTabBar extends StatelessWidget {
  MyTabBar(
      {super.key,
      this.tabAlignment,
      this.isScrollable = false,
      required this.tabs});

  final List<Widget> tabs;
  TabAlignment? tabAlignment;
  bool? isScrollable;
  @override
  Widget build(BuildContext context) {
    return TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        dividerColor: Colors.transparent,
        indicatorPadding: const EdgeInsets.symmetric(vertical: 4),
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color.fromRGBO(0, 121, 107, 0.8))),
        labelStyle: const TextStyle(
          fontSize: 16,
        ),
        tabs: tabs);
  }
}
