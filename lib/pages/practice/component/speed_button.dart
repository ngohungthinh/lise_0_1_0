import 'package:flutter/material.dart';
import 'package:lise_0_1_0/provider/audio_provider.dart';
import 'package:provider/provider.dart';

class SpeedButton extends StatelessWidget {
  const SpeedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<AudioProvider, double>(
      selector: (_, provider) => provider.currentSpeed,
      builder: (_, value, __) => Stack(
        children: [
          // text 1x 2x 0.5x ...
          Positioned(
            top: 0,
            left: 10,
            child: Text(
              "${value}x",
              style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ),
          // button
          PopupMenuButton<double>(
            popUpAnimationStyle: AnimationStyle(
              curve: Curves.easeOutQuart,
            ),
            color: Colors.white,
            menuPadding: const EdgeInsets.all(0),
            constraints: const BoxConstraints(maxWidth: 100),
            icon: const Icon(Icons.speed),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 0.25, child: Text("0.25")),
              const PopupMenuItem(value: 0.5, child: Text("0.5")),
              const PopupMenuItem(value: 0.75, child: Text("0.75")),
              const PopupMenuItem(value: 1, child: Text("Normal")),
              const PopupMenuItem(value: 1.25, child: Text("1.25")),
              const PopupMenuItem(value: 1.5, child: Text("1.5")),
              const PopupMenuItem(value: 1.75, child: Text("1.75")),
              const PopupMenuItem(value: 2, child: Text("2")),
            ],
            onSelected: (value) =>
                context.read<AudioProvider>().setSpeed(value),
          ),
        ],
      ),
    );
  }
}
