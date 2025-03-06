import 'package:hive_ce_flutter/hive_flutter.dart';

class Sentence extends HiveObject {
  final String originalScript;
  final String translatedScript;
  final int startTime; // milisecond

  Sentence({
    required this.originalScript,
    required this.translatedScript,
    required this.startTime,
  });
}
