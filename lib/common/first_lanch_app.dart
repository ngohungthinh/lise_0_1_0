import 'dart:io';

import 'package:flutter/services.dart';
import 'package:lise_0_1_0/common/reference.dart';
import 'package:lise_0_1_0/model/lesson.dart';
import 'package:lise_0_1_0/model/sentence.dart';

// First Run App
Future<void> firstRunApp() async {
  // Nếu length Sample Lesson trong Box == 0 là lần đầu chạy app
  if (sampleLessonBox.length == 0) {
    await initializeAudioFiles();
    await sampleLessonBox.addAll(sampleLesson);
    await lessonBox.addAll(initLessons);
  }
}

//------------------------------------

// Lưu file từ Asset vào App Directory. va update lai List Lesson mẫu
Future<void> initializeAudioFiles() async {
  for (int i = 0; i < sampleLesson.length; i++) {
    sampleLesson[i].audioPath =
        await saveAudioAssetToDisk(sampleLesson[i].audioPath);
  }

  for (int i = 0; i < initLessons.length; i++) {
    initLessons[i].audioPath =
        await saveAudioAssetToDisk(initLessons[i].audioPath);
  }
}

//Đường dẫn audio sẽ là: /audio/432432432/name_audio.
Future<String> saveAudioAssetToDisk(String audioAssetUrl) async {
  // CREATE FOLDER TO SAVE
  // get filename
  String fileName = audioAssetUrl.substring(audioAssetUrl.lastIndexOf('/') + 1);
  // Create a unique directory path
  final uniqueName = "${DateTime.now().millisecondsSinceEpoch}";
  final newDirectoryPath = "${directoryApp.path}/audio/$uniqueName";

  // Ensure the directory exists
  final newDirectory = Directory(newDirectoryPath);
  if (!newDirectory.existsSync()) {
    await newDirectory.create(recursive: true);
  }
  // Create the new file path
  final newPath = "$newDirectoryPath/$fileName";

  // SAVE
  final byteData = await rootBundle.load(audioAssetUrl);
  final file = File(newPath);
  await file.writeAsBytes(byteData.buffer.asInt8List());
  return file.path;
}

// ---------DATA mặc định-----------
List<Lesson> sampleLesson = [
  Lesson(
    name: "Introduction",
    audioPath: 'asset/audio/restaurant.mp3',
    originalSource: "",
    translatedSource: "",
    sentences: [
      Sentence(
        originalScript:
            "Thank you for talking to me today. What would you like to talk about?",
        translatedScript:
            "Cảm ơn bạn đã nói chuyện với tôi hôm nay. Bạn muốn nói về điều gì?",
        startTime: 12000,
      ),
      Sentence(
        originalScript:
            "Thank you for talking to me today. What would you like to talk about?",
        translatedScript:
            "Cảm ơn bạn đã nói chuyện với tôi hôm nay. Bạn muốn nói về điều gì?",
        startTime: 15000,
      ),
    ],
  ),
  Lesson(
    name: "Study Trip",
    audioPath: 'asset/audio/study_trip.mp3',
    originalSource: "",
    translatedSource: "",
    sentences: [
      Sentence(
        originalScript:
            "Thank you for talking to me today. What would you like to talk about?",
        translatedScript:
            "Cảm ơn bạn đã nói chuyện với tôi hôm nay. Bạn muốn nói về điều gì?",
        startTime: 12000,
      ),
      Sentence(
        originalScript:
            "Thank you for talking to me today. What would you like to talk about?",
        translatedScript:
            "Cảm ơn bạn đã nói chuyện với tôi hôm nay. Bạn muốn nói về điều gì?",
        startTime: 15000,
      ),
    ],
  ),
];

//---------------------------------------

List<Lesson> initLessons = [
  Lesson(
    name: "Introduction",
    audioPath: "asset/audio/restaurant.mp3",
    originalSource:
        "dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad adfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad",
    translatedSource:
        "dasfsadfdas sjlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f saddajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad dasfsadfdas sdajlf jsjd fjas; dj;f sad",
    sentences: [
      Sentence(
        originalScript:
            "Thank you for talking to me today. What would you like to talk about?",
        translatedScript:
            "Cảm ơn bạn đã nói chuyện với tôi hôm nay. Bạn muốn nói về điều gì?",
        startTime: 1000,
      ),
      Sentence(
        originalScript:
            "Thank you for talking to me today. What would you like to talk about?",
        translatedScript:
            "Cảm ơn bạn đã nói chuyện với tôi hôm nay. Bạn muốn nói về điều gì?",
        startTime: 2000,
      ),
      Sentence(
        originalScript:
            "Thank you for talking to me today. What would you like to talk about?",
        translatedScript:
            "Cảm ơn bạn đã nói chuyện với tôi hôm nay. Bạn muốn nói về điều gì?",
        startTime: 5000,
      ),
      Sentence(
        originalScript:
            "Thank you for talking to me today. What would you like to talk about?",
        translatedScript:
            "Cảm ơn bạn đã nói chuyện với tôi hôm nay. Bạn muốn nói về điều gì?",
        startTime: 7000,
      ),
      Sentence(
        originalScript:
            "Thank you for talking to me today. What would you like to talk about?",
        translatedScript:
            "Cảm ơn bạn đã nói chuyện với tôi hôm nay. Bạn muốn nói về điều gì?",
        startTime: 9000,
      ),
      Sentence(
        originalScript:
            "Thank you for talking to me today. What would you like to talk about?",
        translatedScript:
            "Cảm ơn bạn đã nói chuyện với tôi hôm nay. Bạn muốn nói về điều gì?",
        startTime: 12000,
      ),
      Sentence(
        originalScript:
            "Thank you for talking to me today. What would you like to talk about?",
        translatedScript:
            "Cảm ơn bạn đã nói chuyện với tôi hôm nay. Bạn muốn nói về điều gì?",
        startTime: 15000,
      ),
      Sentence(
        originalScript:
            "Thank you for talking to me today. What would you like to talk about?",
        translatedScript:
            "Cảm ơn bạn đã nói chuyện với tôi hôm nay. Bạn muốn nói về điều gì?",
        startTime: 19000,
      ),
    ],
  ),
  Lesson(
    name: "Init",
    audioPath: "asset/audio/study_trip.mp3",
    originalSource: "",
    translatedSource: "",
    sentences: [
      Sentence(
        originalScript:
            "Thank you for talking to me today. What would you like to talk about?",
        translatedScript:
            "Cảm ơn bạn đã nói chuyện với tôi hôm nay. Bạn muốn nói về điều gì?",
        startTime: 15000,
      ),
      Sentence(
        originalScript:
            "Thank you for talking to me today. What would you like to talk about?",
        translatedScript:
            "Cảm ơn bạn đã nói chuyện với tôi hôm nay. Bạn muốn nói về điều gì?",
        startTime: 15000,
      ),
    ],
  ),
];
