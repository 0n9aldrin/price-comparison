import 'package:flutter/material.dart';
import 'drawer.dart';
import 'home_page.dart';

class CombinedHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [DrawerScreen(), MyHomePage()],
      ),
    );
  }
}
