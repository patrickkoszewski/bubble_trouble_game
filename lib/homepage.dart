import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.pink[100],
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.grey,
            child: Row(
              children: [],
            ),
          ),
        ),
      ],
    );
  }
}
