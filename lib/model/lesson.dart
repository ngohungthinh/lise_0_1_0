import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:lise_0_1_0/model/sentence.dart';

class Lesson extends HiveObject {
  String name;
  String audioPath;
  String originalSource;
  String translatedSource;
  List<Sentence> sentences;

  Lesson({
    required this.name,
    required this.audioPath,
    required this.originalSource,
    required this.translatedSource,
    required this.sentences,
  });
}
