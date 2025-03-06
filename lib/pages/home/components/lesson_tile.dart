import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lise_0_1_0/pages/components/ellipsis_text.dart';
import 'package:lise_0_1_0/pages/edit/edit_page.dart';
import 'package:lise_0_1_0/pages/play/play_page.dart';
import 'package:lise_0_1_0/model/lesson.dart';
import 'package:lise_0_1_0/model/sentence.dart';
import 'package:lise_0_1_0/provider/audio_provider.dart';
import 'package:lise_0_1_0/provider/edit_provider.dart';
import 'package:lise_0_1_0/provider/play_list_provider.dart';
import 'package:lise_0_1_0/provider/play_provider.dart';
import 'package:provider/provider.dart';

class LessonTile extends StatelessWidget {
  final Lesson lesson;

  const LessonTile({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    // Lấy ra 5 câu Original Script để xuất ra UI.
    List<Sentence> sentences5 =
        lesson.sentences.sublist(0, min(lesson.sentences.length, 5));
    List<String> originScript5 =
        sentences5.map((sentence) => sentence.originalScript).toList();
    return GestureDetector(
      // Tap để qua trang Play
      onTap: () async {
        // Set Source bài hát.
        AudioProvider audioProvider = context.read<AudioProvider>();
        await audioProvider.setSourcePlayer(lesson);

        // Đi qua trang play.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (context) => PlayProvider(
                currentLesson: lesson,
                player: audioProvider.player,
              ),
              child: const PlayPage(),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 7),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    child: Text(
                      lesson.name,
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ),
                // Button delete and edit
                PopupMenuButton<int>(
                  popUpAnimationStyle: AnimationStyle.noAnimation,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 0,
                        child: Text(
                          "Edit",
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.grey.shade900),
                        ),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: Text(
                          "Delete",
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.grey.shade900),
                        ),
                      )
                    ];
                  },
                  icon: const Icon(
                    Icons.more_horiz,
                  ),
                  onSelected: (value) {
                    onPressed(value, context);
                  },
                )
              ],
            ),

            EllipsisText(
              originScript5,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }

  void onPressed(int value, BuildContext contextOrigin) {
    // If Delete
    if (value == 1) {
      showDialog(
        context: contextOrigin,
        builder: (context) {
          return AlertDialog(
            title: const Text("Would you like delete permanently?"),
            actions: [
              TextButton(
                onPressed: () {
                  contextOrigin.read<PlayListProvider>().removeLesson(lesson);
                  Navigator.pop(context);
                },
                child: const Text("Delete"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        },
      );

      return;
    }

    // If is Edit
    // Qua trang Edit và Play nhạc
    final AudioProvider audioProvider = contextOrigin.read<AudioProvider>();
    audioProvider.setSourcePlayer(lesson);

    // Delay khi  chuyển page để khỏi bị hiệu ứng lag ở PopupmenuButton.
    Future.delayed(const Duration(milliseconds: 30), () {
      Navigator.push(
        // ignore: use_build_context_synchronously
        contextOrigin,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => EditProvider(
                lesson: lesson,
                player: audioProvider.player,
                isUpdateLesson: true),
            child: const EditPage(),
          ),
        ),
      );
    });
  }
}
