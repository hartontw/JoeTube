import 'package:flutter/material.dart';
import 'package:joetube/widgets/main_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(body: _buildBody());
  }

  Widget _buildBody() {
    return const Text("HomeScreen");
  }
}
