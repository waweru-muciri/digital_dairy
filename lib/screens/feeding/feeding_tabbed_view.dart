import 'package:DigitalDairy/screens/feeding/feeding.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class FeedingTabView extends StatelessWidget {
  const FeedingTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const MyDrawer(),
        appBar: AppBar(
          bottom: TabBar(
            dividerColor: Colors.transparent,
            indicatorPadding: const EdgeInsets.symmetric(vertical: 4),
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: const Color.fromRGBO(0, 121, 107, 0.8))),
            labelStyle: const TextStyle(
              fontSize: 16,
            ),
            tabs: [
              Tab(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  alignment: Alignment.center,
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    color: Color.fromRGBO(0, 121, 107, 0.1),
                  ),
                  child: const Text("Feed Items"),
                ),
              ),
              Tab(
                  child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                alignment: Alignment.center,
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  color: Color.fromRGBO(0, 121, 107, 0.1),
                ),
                child: const Text("Feeding Schedule"),
              )),
            ],
          ),
          title: const Text("Feeding"),
        ),
        body: const TabBarView(
          children: [
            FeedingsScreen(),
            Center(
              child: Text("Feeding Schedule"),
            ),
          ],
        ),
      ),
    );
  }
}
