import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class CricketThree extends StatefulWidget {
  const CricketThree({super.key});

  @override
  State<CricketThree> createState() => _CricketThreeState();
}

class _CricketThreeState extends State<CricketThree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('reborn 3'),
        leading: IconButton(onPressed: () {}, icon: Icon(Ionicons.menu)),
      ),
    );
  }
}