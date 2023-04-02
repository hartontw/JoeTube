import 'package:flutter/material.dart';

class PlayerBar extends StatelessWidget {
  const PlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: const [
      Icon(
        Icons.play_arrow,
        color: Colors.blue,
      ),
      Text(
        "PlayerBar",
        textAlign: TextAlign.center,
      )
    ]);
  }
}
