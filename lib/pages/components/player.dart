import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lise_0_1_0/common/function.dart';
import 'package:lise_0_1_0/provider/audio_provider.dart';
import 'package:provider/provider.dart';

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  // Canh để đang kéo Slider thì không seek audio.
  bool isDrag = false;
  double currentValueDrag = 0;

  @override
  Widget build(BuildContext context) {
    final AudioProvider provider = context.watch<AudioProvider>();
    // Do giá trị position stream phát ra lần cuối lớn hơn thời lượng tổng của audio. Nên mới thêm cái này.
    final double maxTime = provider.totalDuration.inSeconds.toDouble();
    final double currentTime = provider.currentDuration.inSeconds.toDouble();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 120,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),

            // Slider
            Row(
              children: [
                // Start Time
                Text(
                  isDrag
                      ? formatTime(Duration(seconds: currentValueDrag.toInt()))
                      : formatTime(currentTime < maxTime
                          ? provider.currentDuration
                          : provider.totalDuration),
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
                const SizedBox(width: 2),

                //Slider
                Expanded(
                  child: Slider(
                    min: 0,
                    max: maxTime,
                    value: isDrag
                        ? currentValueDrag
                        : currentTime < maxTime
                            ? currentTime
                            : maxTime,
                    onChangeStart: (value) => isDrag = true,
                    onChanged: (value) {
                      setState(
                        () {
                          currentValueDrag = value;
                        },
                      );
                    },
                    onChangeEnd: (double value) {
                      isDrag = false;
                      provider.player.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                ),
                const SizedBox(width: 2),

                // Total time
                Text(
                  formatTime(provider.totalDuration),
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
              ],
            ),

            // Dãy Button bên dưới.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Speed button
                Stack(
                  children: [
                    // text 1x 2x 0.5x ...
                    Positioned(
                      top: 0,
                      left: 10,
                      child: Text(
                        "${provider.currentSpeed}x",
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
                      onSelected: (value) => provider.setSpeed(value),
                    ),
                  ],
                ),

                // Button ngược 5s
                IconButton(
                  onPressed: provider.seek5sBackward,
                  icon: const Icon(
                    Icons.replay_5,
                    size: 40,
                  ),
                ),

                // Play, Pause, RePlay Button
                provider.isCompleted
                    ? IconButton(
                        onPressed: () => provider.player.seek(Duration.zero),
                        icon: const Icon(Icons.replay, size: 50))
                    : provider.isPlaying
                        ? IconButton(
                            onPressed: () => provider.player.pause(),
                            icon: const Icon(Icons.pause, size: 50))
                        : IconButton(
                            onPressed: () => provider.player.play(),
                            icon: const Icon(Icons.play_arrow, size: 50)),

                // Button tua tới 5s
                IconButton(
                  onPressed: provider.seek5sForward,
                  icon: const Icon(
                    Icons.forward_5,
                    size: 40,
                  ),
                ),

                // Button Loop
                IconButton(
                  onPressed: provider.toggleLoop,
                  icon: Icon(
                    Icons.repeat,
                    size: 25,
                    color: provider.isLoop == LoopMode.off
                        ? Colors.grey
                        : Colors.lightBlue,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
