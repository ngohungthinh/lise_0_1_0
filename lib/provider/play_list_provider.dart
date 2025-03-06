import 'package:flutter/foundation.dart';
import 'package:lise_0_1_0/common/function.dart';
import 'package:lise_0_1_0/common/reference.dart';
import 'package:lise_0_1_0/model/lesson.dart';

class PlayListProvider extends ChangeNotifier {
  late List<Lesson> lessons = lessonBox.values.toList();
  late List<Lesson> sampleLessons = sampleLessonBox.values.toList();

  void removeLesson(Lesson lesson) async {
    // delete audio file trong App Directory
    deleteFileAndParentFolder(lesson.audioPath);

    // delete trong database
    await lesson.delete();

    // update lại list lesson ở UI
    lessons = lessonBox.values.toList();
    notifyListeners();
  }

  void addLesson(Lesson lesson) async {
    // add trong database
    await lessonBox.add(lesson);

    // update lại list lesson ở UI
    lessons = lessonBox.values.toList();
    notifyListeners();
  }

  void updateLesson({required Lesson lesson, required Lesson newLesson}) async {
    // Update đường dẫn file Audio. Nếu khác với cái ban đầu thì mới Update
    if (newLesson.audioPath != lesson.audioPath) {
      // Xóa audio cũ, Lưu audio mới và update đường dẫn newLesson
      deleteFileAndParentFolder(lesson.audioPath);
      final file = await saveFilePermanently(newLesson.audioPath);
      newLesson.audioPath = file.path;
    }

    // Gán giá trị Lesson mới cho lesson đang update và save lại
    lesson
      ..name = newLesson.name
      ..audioPath = newLesson.audioPath
      ..sentences = newLesson.sentences
      ..originalSource = newLesson.originalSource
      ..translatedSource = newLesson.translatedSource;

    await lesson.save();
    lessons = lessonBox.values.toList();
    notifyListeners();
  }
}
