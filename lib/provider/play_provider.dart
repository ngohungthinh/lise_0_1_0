import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lise_0_1_0/common/function.dart';
import 'package:lise_0_1_0/model/lesson.dart';
import 'package:lise_0_1_0/model/sentence.dart';

class PlayProvider extends ChangeNotifier {
  final Lesson currentLesson;
  final AudioPlayer player;
  Sentence? currentSentencePlay;
  Sentence? currentSentenceTap;

  // Custom timer------------------------------------
  bool isShowCustomTimer = false;
  bool isOriginalTime = true;
  Duration totalTimeAudio = Duration.zero;
  Duration timeStart = Duration.zero;
  Duration timeEnd = Duration.zero;
  List<int> pickTimeStart = [0, 0, 0, 0, 0];
  List<int> pickTimeEnd = [0, 0, 0, 0, 0];

  // CONTRUCTOR--------------------------------------
  // Get stream to Dispose
  late StreamSubscription<Duration> positionStream;
  late StreamSubscription<Duration?> durationStream;
  PlayProvider({required this.currentLesson, required this.player}) {
    // Lắng nghe để biết currentSentencePlay
    positionStream = player.positionStream.listen((duration) {
      // Xem thử duration hiện tại sát (lớn nhất) với câu nào nhất.
      Sentence? sentencePlay;
      for (int i = 0; i < currentLesson.sentences.length; i++) {
        Sentence sentenceI = currentLesson.sentences[i];
        // Cái chỗ - timeStart để trường hợp Custom time thì thời gian của Sentence phải trừ cho timeStart
        if (sentenceI.startTime - timeStart.inMilliseconds <=
            duration.inMilliseconds) {
          sentencePlay = sentenceI;
        } else {
          break;
        }
      }
      // Khi CurrentPlay có thay đổi thì Update lại currentPlay.
      // Cộng update lại CurrentTap. Nhỡ đâu CurrentPlay là CurrentTap, thì khi update Play mới thì phải xóa Tap
      if (currentSentencePlay != sentencePlay) {
        currentSentencePlay = sentencePlay;
        // Kiểm tra CurrentTap
        if (currentSentencePlay != currentSentenceTap) {
          currentSentenceTap = null;
        }
        notifyListeners();
      }
    });

    // Lắng nghe tổng thời lượng audio.
    durationStream = player.durationStream.listen((duration) {
      if (isOriginalTime == true) timeEnd = duration ?? Duration.zero;
      if (totalTimeAudio == Duration.zero) {
        totalTimeAudio = duration ?? Duration.zero;
      }
      notifyListeners();
    });
  }

  //--------------------Function Play Sentence--------------

  Future<void> changeCurrentSentenceTap(int indexSentenceTap) async {
    final sentences = currentLesson.sentences;

    // set currentCentence
    currentSentenceTap = sentences[indexSentenceTap];

    // Seek Audio.
    // Nếu câu Tap có startTime lớn hơn thời lượng của audio (Lỗi). Thì Seek hết audio.
    // Trường hợp Custom Time thì phải trừ cho startTime.
    int startTimeSen = currentSentenceTap!.startTime - timeStart.inMilliseconds;
    if (startTimeSen > player.duration!.inMilliseconds) {
      player.seek(player.duration!);
    } else {
      // Seek Player tai vi tri SentenceTap
      if (startTimeSen >= 0) {
        player.seek(Duration(milliseconds: startTimeSen));
      } else {
        // Nếu vị trí của sentenceTap là câu cuối cùng hoặc startTime câu thứ i + 1 > 0 thì seek 0. Do start câu này nhỏ hơn 0
        if (indexSentenceTap == sentences.length - 1 ||
            sentences[indexSentenceTap + 1].startTime -
                    timeStart.inMilliseconds >
                0) {
          player.seek(Duration.zero);
        }
      }
    }

    notifyListeners();
  }

  // loop sentense
  StreamSubscription<Duration>? streamLoop;
  void toggleLoopSentence({required bool isLoop, int? indexSentenceLoop}) {
    if (isLoop == true) {
      final sentences = currentLesson.sentences;

      // Khi có custom Time thì phải trừ cho Start mới ra time của câu. Nếu Timestart nhở hơn 0 thì seek 0.
      int startTimeLoop = max(
          sentences[indexSentenceLoop!].startTime - timeStart.inMilliseconds,
          0);
      late int endTimeLoop;

      // Tìm End Time loop của câu
      // Nếu sentenLoop là câu cuối cùng. thì Endtime là cuối của Audio.
      // Nếu chưa phải là câu cuối thì End time là start của câu kế.
      if (indexSentenceLoop == sentences.length - 1) {
        endTimeLoop = player.duration!.inMilliseconds;
      } else {
        endTimeLoop = sentences[indexSentenceLoop + 1].startTime -
            timeStart.inMilliseconds;
      }

      // Tiến hành Loop
      streamLoop = player.positionStream.listen((duration) {
        if (duration.inMilliseconds >= endTimeLoop) {
          player.seek(Duration(milliseconds: startTimeLoop));
        }
      });
    } else {
      if (streamLoop != null) {
        streamLoop!.cancel();
        streamLoop = null;
      }
    }
  }

  //-----Function custom time---------------------

  void changeShowCustomTimer() {
    isShowCustomTimer = !isShowCustomTimer;
    notifyListeners();
  }

  void applyCustomTime() async {
    int startMiliPick = toMilisecond(pickTimeStart);
    int endMiliPick = toMilisecond(pickTimeEnd);

    if (startMiliPick >= endMiliPick) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: "End time must bigger than start time");
      return;
    }

    if (startMiliPick > totalTimeAudio.inMilliseconds) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: "Start time must within 0:00 - ${formatTime(totalTimeAudio)}");
      return;
    }

    timeStart = Duration(milliseconds: startMiliPick);
    timeEnd = Duration(milliseconds: endMiliPick);

    player.setClip(start: timeStart, end: timeEnd);
    isOriginalTime = false;

    notifyListeners();
  }

  void resetCustomTime() {
    timeStart = Duration.zero;
    player.setClip();
    isOriginalTime = true;

    notifyListeners();
  }

  void reactCustomTime() {
    notifyListeners();
  }

  //--------------------Dispose---------------
  @override
  void dispose() {
    if (streamLoop != null) streamLoop!.cancel();
    positionStream.cancel();
    durationStream.cancel();
    // Stop Audio
    player.stop();
    super.dispose();
  }
}
