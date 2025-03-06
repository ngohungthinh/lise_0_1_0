import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lise_0_1_0/common/function.dart';
import 'package:lise_0_1_0/model/lesson.dart';
import 'package:lise_0_1_0/model/sentence.dart';

class EditProvider extends ChangeNotifier {
  final bool isUpdateLesson;
  late final Lesson? originalLesson;
  Lesson lesson;
  final AudioPlayer player;

  // Add sentence------
  TextSelection? originalSelection;
  TextSelection? translatedSelection;

  // Player------------
  Sentence? currentSentencePlay;
  // Get Stream to Dispose
  late StreamSubscription<Duration> positionStream;

  // -------
  // Theo dõi các Sentence đã được add gần đây
  List<Sentence> logSentences = [];
  // Theo dõi thời gian điều chỉnh
  final List<int> timeStart = [0, 0, 0, 0, 0];

  // --------CONTRUCTOR------
  EditProvider({
    required this.lesson,
    required this.player,
    this.isUpdateLesson = false,
  }) {
    // Nếu là update Lesson có sẵn, thì ta tạo ra 1 phiên bản Lesson tương tự. Lưu lesson cũ ở originalLesson
    // Ta cứ thao tác trên lesson tương tự. Sẽ k ảnh hưởng Lesson cũ.
    if (isUpdateLesson == true) {
      originalLesson = lesson;
      lesson = Lesson(
          name: originalLesson!.name,
          audioPath: originalLesson!.audioPath,
          originalSource: originalLesson!.originalSource,
          translatedSource: originalLesson!.translatedSource,
          sentences: List.from(
            originalLesson!.sentences,
          ));
    }

    // Theo dõi currentSentencePlay
    positionStream = player.positionStream.listen((duration) {
      // Xem thử duration hiện tại sát (lớn nhất) với câu nào nhất.
      Sentence? sentencePlay;
      for (int i = 0; i < lesson.sentences.length; i++) {
        Sentence sentenceI = lesson.sentences[i];
        if (sentenceI.startTime <= duration.inMilliseconds) {
          sentencePlay = sentenceI;
        } else {
          break;
        }
      }

      // Khi CurrentPlay có thay đổi thì Update lại currentPlay.
      if (currentSentencePlay != sentencePlay) {
        currentSentencePlay = sentencePlay;
        notifyListeners();
      }
    });
  }

  //--------------Player------------------
  // Play sentence tap
  void playSentence(Sentence sentence) async {
    // Nếu câu Play có start Time lớn hơn thời lượng audio.
    if (sentence.startTime > player.duration!.inMilliseconds) {
      player.seek(player.duration!);
      return;
    }
    await player.seek(Duration(milliseconds: sentence.startTime));
    player.play();
  }

  //-----------Update name, audio, sentence Function----------
  void deleteSentence(Sentence sentence) {
    // Xóa sentence ở listen và trong mục theo dõi các sentence thay đổi.
    lesson.sentences.remove(sentence);
    logSentences.remove(sentence);
    notifyListeners();
  }

  void addSentence(Sentence sentence) {
    List<Sentence> currentSentences = lesson.sentences;
    int posInsert = 0;
    for (int i = currentSentences.length - 1; i >= 0; i--) {
      if (sentence.startTime > currentSentences[i].startTime) {
        posInsert = i + 1;
        break;
      }
    }
    currentSentences.insert(posInsert, sentence);
    // Thêm sentence ở listen và trong mục theo dõi các sentence thay đổi.
    logSentences.add(sentence);

    notifyListeners();
  }

  void addSentenceHighlight() {
    // Lấy ra thời gian và Script của câu
    String originalScript =
        getSelectedText(lesson.originalSource, originalSelection);
    String translatedScript =
        getSelectedText(lesson.translatedSource, translatedSelection);
    int startTime = toMilisecond(timeStart);

    if (originalScript.isEmpty) {
      Fluttertoast.showToast(
          msg: "Highlight the sentence you want from the source text",
          toastLength: Toast.LENGTH_LONG);
      return;
    }

    // Tạo ra câu chuẩn bị Add
    Sentence sentence = Sentence(
        originalScript: originalScript,
        translatedScript: translatedScript,
        startTime: startTime);

    // ADD
    addSentence(sentence);
  }

  void setSoutceText(String originalSource, String translatedSource) {
    lesson.originalSource = originalSource;
    lesson.translatedSource = translatedSource;
    notifyListeners();
  }

  void updateName(String name) {
    lesson.name = name;
    notifyListeners();
  }

  void updateAudio(String audioPath) {
    player.setFilePath(audioPath);
    lesson.audioPath = audioPath;
  }

  // Help------
  String getSelectedText(String paragraph, TextSelection? selection) {
    if (selection == null) return "";
    return paragraph.substring(selection.start, selection.end).trim();
  }
  // Help------

  //-------------Dispose---------------
  @override
  void dispose() {
    positionStream.cancel();
    player.stop();
    super.dispose();
  }
}
