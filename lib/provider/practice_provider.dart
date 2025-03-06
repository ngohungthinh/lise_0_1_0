import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lise_0_1_0/model/lesson.dart';

class PracticeProvider extends ChangeNotifier {
  final Lesson lesson;
  late int indexCurrentSentence;
  final AudioPlayer player;

  PracticeProvider({required this.lesson, required this.player}) {
    indexCurrentSentence = lesson.sentences.isEmpty ? -1 : 0;
  }

  void changeIndexCurrent(int i) {
    indexCurrentSentence = i;
    notifyListeners();
  }

  StreamSubscription<Duration>? playStream;
  void playSentence() async {
    // Khi không có câu nào thì dừng.
    if (indexCurrentSentence == -1) return;

    // Khi Play câu chọn trước đó chưa xong thì hủy. Để chạy câu mới
    if (playStream != null) {
      await playStream!.cancel();
      playStream = null;
    }

    // Tìm Endtime của câu
    Duration timeEnd = indexCurrentSentence == lesson.sentences.length
        ? player.duration!
        : Duration(
            milliseconds: lesson.sentences[indexCurrentSentence + 1].startTime);

    // Seek tại vị trí Câu đang ở.
    await player.seek(Duration(
        milliseconds: lesson.sentences[indexCurrentSentence].startTime));

    // Canh khi tới time end thì dừng lại.
    playStream = player.positionStream.listen((duration) {
      if (duration >= timeEnd) {
        player.pause();
        playStream!.cancel();
        playStream = null;
      }
    });

    player.play();
  }

  @override
  void dispose() {
    if (playStream != null) playStream!.cancel();
    super.dispose();
  }
}
