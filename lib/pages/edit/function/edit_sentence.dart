import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lise_0_1_0/common/function.dart';
import 'package:lise_0_1_0/pages/components/time_picker.dart';
import 'package:lise_0_1_0/model/sentence.dart';
import 'package:lise_0_1_0/pages/edit/function/content_popup_edit.dart';
import 'package:lise_0_1_0/provider/audio_provider.dart';
import 'package:lise_0_1_0/provider/edit_provider.dart';
import 'package:provider/provider.dart';

void showDialogEdit(BuildContext contextOrigin, Sentence sentence) {
  // Vài biến để lấy dữ liệu của Sentence cũ
  final List<int> timeStart = milisecToListTime(sentence.startTime);
  final TextEditingController oriController = TextEditingController();
  final TextEditingController tranController = TextEditingController();
  oriController.text = sentence.originalScript;
  tranController.text = sentence.translatedScript;

  showDialog(
    context: contextOrigin,
    builder: (context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        contentPadding: const EdgeInsets.only(left: 18, right: 18, bottom: 30),
        titlePadding:
            const EdgeInsets.only(left: 18, right: 5, top: 20, bottom: 20),
        // Pick time
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Pick time
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TimePicker(time: timeStart),
                IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () => testVoiceInTime(contextOrigin, timeStart),
                  icon: Icon(
                    Icons.volume_up_outlined,
                    size: 35,
                    color: Colors.grey.shade700,
                  ),
                )
              ],
            ),

            // Button Pause and Play
            StreamBuilder(
              stream: context.read<AudioProvider>().player.playingStream,
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return IconButton(
                      onPressed: () =>
                          context.read<AudioProvider>().player.pause(),
                      icon: Icon(
                        Icons.pause,
                        size: 40,
                        color: Colors.grey.shade900,
                      ));
                }

                return IconButton(
                    onPressed: () =>
                        context.read<AudioProvider>().player.play(),
                    icon: Icon(
                      Icons.play_arrow,
                      size: 40,
                      color: Colors.grey.shade900,
                    ));
              },
            ),
          ],
        ),
        // Script sentence Text
        content: ContentPopupEdit(
            oriController: oriController, tranController: tranController),

        // Save and Cancel Button
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: () {
              Sentence updateSentence = Sentence(
                originalScript: oriController.text,
                translatedScript: tranController.text,
                startTime: toMilisecond(timeStart),
              );

              // Xóa Sentence cũ và thêm sentence update vào. Delay để UI nó update. Chớ nhanh quá nó không update.
              // Do UI theo dõi độ dài của List sentence. Xóa nhanh quá nó k phát hiện ra.
              EditProvider editProvider = contextOrigin.read<EditProvider>();
              editProvider.deleteSentence(sentence);
              Future.delayed(const Duration(milliseconds: 500),
                  () => editProvider.addSentence(updateSentence));

              Navigator.pop(context);
            },
            child: const Text("Update"),
          )
        ],
      );
    },
  );
}

void testVoiceInTime(BuildContext context, List<int> time) {
  AudioProvider audioProvider = context.read<AudioProvider>();

  // Nếu time lớn hơn thời lượng Audio thì seek hết bài. Ngược lại thì seek tại vị trí time.
  int timeMiliSec = toMilisecond(time);
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
