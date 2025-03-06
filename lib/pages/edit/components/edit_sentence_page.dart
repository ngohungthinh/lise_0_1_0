import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lise_0_1_0/common/function.dart';
import 'package:lise_0_1_0/pages/edit/components/edit_panel.dart';
import 'package:lise_0_1_0/pages/components/time_picker.dart';
import 'package:lise_0_1_0/provider/audio_provider.dart';
import 'package:lise_0_1_0/provider/edit_provider.dart';
import 'package:provider/provider.dart';

class EditSentencePage extends StatelessWidget {
  const EditSentencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        // Phần custom sentence
        Expanded(
          child: Container(
            margin:
                const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 3),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Expanded(child: EditPanel(isOriginal: true)),
                Container(
                  height: 1,
                  color: Colors.white,
                  // margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                const Expanded(child: EditPanel(isOriginal: false)),
              ],
            ),
          ),
        ),

        // Phần Picktime, Button
        Container(
          height: 45,
          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Pick time
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TimePicker(time: context.read<EditProvider>().timeStart),
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () => testVoiceInTime(context),
                    icon: Icon(
                      Icons.volume_up_outlined,
                      size: 35,
                      color: Colors.grey.shade700,
                    ),
                  )
                ],
              ),
              // Add sentence button
              Row(
                children: [
                  OutlinedButton(
                      onPressed: () {
                        context.read<EditProvider>().addSentenceHighlight();
                      },
                      child: const Text("Add")),
                  IconButton(
                    onPressed: () {},
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(Icons.more_vert),
                  )
                ],
              )
            ],
          ),
        )
      ],
    ));
  }

  void testVoiceInTime(BuildContext context) {
    AudioProvider audioProvider = context.read<AudioProvider>();
    EditProvider editProvider = context.read<EditProvider>();

    // Nếu time lớn hơn thời lượng Audio thì seek hết bài. Ngược lại thì seek tại vị trí time.
    int timeMiliSec = toMilisecond(editProvider.timeStart);
    AudioPlayer player = audioProvider.player;
    if (timeMiliSec > audioProvider.totalDuration.inMilliseconds) {
      player.seek(audioProvider.totalDuration);
      return;
    }
    player.seek(Duration(milliseconds: timeMiliSec));

    // Nếu player đang pause, thì bật audio lên.
    if (player.playing == false) {
      player.play();
    }
  }
}
