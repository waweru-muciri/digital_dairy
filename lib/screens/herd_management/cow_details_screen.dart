import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CowDetailsScreen extends StatefulWidget {
  const CowDetailsScreen({super.key, this.cowId});

  final String? cowId;
  static const routeName = 'details/:cowId';

  @override
  State<StatefulWidget> createState() => CowDetailsScreenState();
}

class CowDetailsScreenState extends State<CowDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cow Details',
          style: TextStyle(),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [Text("Cow Details")]),
      ),
    );
  }
}
