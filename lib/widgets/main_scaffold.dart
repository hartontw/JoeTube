import 'package:flutter/material.dart';
import 'player_bar.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("NavBar"),
      ),
      body: body,
      bottomNavigationBar: const PlayerBar(),
    );
  }
}
