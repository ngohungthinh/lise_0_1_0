import 'package:flutter/material.dart';
import 'package:lise_0_1_0/common/function.dart';
import 'package:lise_0_1_0/model/sentence.dart';
import 'package:lise_0_1_0/pages/components/shadow_scrollable.dart';
import 'package:lise_0_1_0/provider/play_provider.dart';
import 'package:provider/provider.dart';

class PlayTile extends StatelessWidget {
  final Sentence sentence;
  final int indexSentence;
  const PlayTile(
      {super.key, required this.sentence, required this.indexSentence});

  // Thời gian ở Milisesond. Khi sentence ở trong khoảng Time hoặc sentence i + 1 ở trong khoảng time thì sentence có 1 phần có thể Play đc.
  bool checkSentenceIsCanPlay(
      int startTime, int endTime, List<Sentence> sentences) {
    if (startTime <= sentence.startTime && sentence.startTime < endTime) {
      return true;
    }
    if (indexSentence < sentences.length - 1) {
      Sentence nextSentence = sentences[indexSentence + 1];
      if (startTime < nextSentence.startTime &&
          nextSentence.startTime < endTime) {
        return true;
      }
    }
    return false;
  }

  bool checkSentenceIsInCustomTime(
      int startTime, int endTime, List<Sentence> sentences) {
    if (startTime <= sentence.startTime && sentence.startTime < endTime) {
      return true;
    }
    if (indexSentence < sentences.length - 1) {
      Sentence nextSentence = sentences[indexSentence + 1];
      if (startTime < nextSentence.startTime &&
          sentence.startTime < startTime &&
          startTime < endTime) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bool isPlay = context.select<PlayProvider, bool>(
        (provider) => provider.currentSentencePlay == sentence);
    final bool isTap = context.select<PlayProvider, bool>(
        (provider) => provider.currentSentenceTap == sentence);
    final bool isCanPlay = context.select<PlayProvider, bool>(
      (provider) => checkSentenceIsCanPlay(provider.timeStart.inMilliseconds,
          provider.timeEnd.inMilliseconds, provider.currentLesson.sentences),
    );
    final bool isInCustomTime = context.select<PlayProvider, bool>(
      (provider) =>
          provider.isShowCustomTimer &&
          checkSentenceIsInCustomTime(
              toMilisecond(provider.pickTimeStart),
              toMilisecond(provider.pickTimeEnd),
              provider.currentLesson.sentences),
    );
    PlayProvider provider = context.read<PlayProvider>();
    return GestureDetector(
      onTap: () => provider.changeCurrentSentenceTap(indexSentence),
      onLongPress: () => showDetailSentence(context),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Original Text
            Text(
              sentence.originalScript,
              style: TextStyle(
                color: isPlay
                    ? Colors.white
                    : isInCustomTime
                        ? Colors.yellow
                        : isCanPlay
                            ? Colors.black
                            : const Color.fromARGB(255, 131, 130, 130),
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            // Translated Text

            Visibility(
              visible: isTap,
              child: Text(
                sentence.translatedScript,
                style: TextStyle(
                    color: isPlay
                        ? Colors.white
                        : isCanPlay
                            ? Colors.black
                            : const Color.fromARGB(255, 131, 130, 130),
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showDetailSentence(BuildContext originContext) async {
    PlayProvider playProvider = originContext.read<PlayProvider>();
    bool isLoopSentence = false;

    // Scroll để track vị trí Script và hiện mờ ở đầu và cuối.
    final oriController = ScrollController();
    final tranController = ScrollController();

    await showDialog(
      context: originContext,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          contentPadding:
              const EdgeInsets.only(left: 18, right: 18, bottom: 30),
          titlePadding:
              const EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 20),
          // Hàng 3 cái Button
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Button Pause and Play
              StreamBuilder(
                stream: playProvider.player.playingStream,
                builder: (context, snapshot) {
                  if (snapshot.data == true) {
                    return IconButton(
                        onPressed: () => playProvider.player.pause(),
                        icon: const Icon(Icons.pause, size: 40));
                  }

                  return IconButton(
                      onPressed: () => playProvider.player.play(),
                      icon: const Icon(Icons.play_arrow, size: 40));
                },
              ),

              Row(
                children: [
                  // Button loop lại sentence
                  StatefulBuilder(
                    builder: (context, setState) => IconButton(
                      onPressed: () {
                        if (isLoopSentence == true) {
                          playProvider.toggleLoopSentence(isLoop: false);
                        } else {
                          playProvider.toggleLoopSentence(
                              isLoop: true, indexSentenceLoop: indexSentence);
                        }

                        setState(() {
                          isLoopSentence = !isLoopSentence;
                        });
                      },
                      icon: Icon(
                        Icons.loop,
                        size: 25,
                        color: isLoopSentence
                            ? Colors.lightBlue.shade800
                            : Colors.grey,
                      ),
                    ),
                  ),
                  // Nghe Button
                  IconButton(
                      onPressed: () {
                        // Seek về thời lượng của câu
                        playProvider.player
                            .seek(Duration(milliseconds: sentence.startTime));
                        // Nếu audio đang tắt thì bật lên
                        if (playProvider.player.playing == false) {
                          playProvider.player.play();
                        }
                      },
                      icon: Icon(
                        Icons.volume_up_outlined,
                        size: 25,
                        color: Colors.grey.shade900,
                      )),
                ],
              ),
            ],
          ),
          // Script sentence Text
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ShadowScrollable(
                  scrollController: oriController,
                  colorShadow: Colors.white,
                  heightShadow: 20,
                  child: SingleChildScrollView(
                    controller: oriController,
                    child: SelectableText(
                      sentence.originalScript,
                      style:
                          const TextStyle(fontSize: 20.5, color: Colors.black),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 25),
                width: MediaQuery.of(context).size.width / 3,
                height: 2,
                color: Colors.lightBlue.shade100,
              ),
              Flexible(
                child: ShadowScrollable(
                  scrollController: tranController,
                  colorShadow: Colors.white,
                  heightShadow: 20,
                  child: SingleChildScrollView(
                    controller: tranController,
                    child: Text(sentence.translatedScript,
                        style: TextStyle(
                            fontSize: 20.5, color: Colors.blue.shade800)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    // Nếu có đang Loop sentence, thì khi thoát Dialog, phải tắt loop.
    if (isLoopSentence == true) {
      playProvider.toggleLoopSentence(isLoop: false);
    }
  }
}
