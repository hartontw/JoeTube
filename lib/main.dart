import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screens/screens.dart';

Future<void> main() async {
  runApp(const JoeTube());
}

class JoeTube extends StatefulWidget {
  const JoeTube({super.key});

  @override
  State<JoeTube> createState() => _JoeTubeState();
}

class _JoeTubeState extends State<JoeTube> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'JoeTube',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              )),
      home: const HomeScreen(),
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
      ],
    );
  }
}
