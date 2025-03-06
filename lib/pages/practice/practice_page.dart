import 'package:flutter/material.dart';
import 'package:lise_0_1_0/model/lesson.dart';
import 'package:lise_0_1_0/pages/practice/component/index_current_wheel.dart';
import 'package:lise_0_1_0/pages/practice/component/speed_button.dart';
import 'package:lise_0_1_0/provider/practice_provider.dart';
import 'package:provider/provider.dart';

class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  bool isShowCheck = false;
  final indexScrollController = FixedExtentScrollController();

  @override
  Widget build(BuildContext context) {
    PracticeProvider practiceProvider = context.read<PracticeProvider>();
    Lesson lesson = practiceProvider.lesson;

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.name),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        indexScrollController.jumpToItem(
                            practiceProvider.indexCurrentSentence - 1);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 30,
                      )),
                  IndexCurrentWheel(
                    scrollController: indexScrollController,
                  ),
                  Text(
                    '/${lesson.sentences.length}',
                    style: const TextStyle(fontSize: 24),
                  ),
                  IconButton(
                    onPressed: () {
                      indexScrollController.jumpToItem(
                          practiceProvider.indexCurrentSentence + 1);
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 30,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const SpeedButton(),
                  IconButton(
                      onPressed: () {
                        practiceProvider.playSentence();
                      },
                      icon: const Icon(
                        Icons.volume_up_outlined,
                        size: 35,
                      ))
                ],
              )
            ],
          ),
          const TextField(
            maxLines: null,
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  isShowCheck = !isShowCheck;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Check"),
                  Icon(isShowCheck
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded)
                ],
              )),
          if (isShowCheck)
            Selector<PracticeProvider, int>(
              selector: (_, provider) => provider.indexCurrentSentence,
              builder: (_, value, __) =>
                  Text(practiceProvider.lesson.sentences[value].originalScript),
            ),
        ],
      ),
    );
  }
}
