import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lise_0_1_0/pages/components/ellipsis_text.dart';
import 'package:lise_0_1_0/model/lesson.dart';
import 'package:lise_0_1_0/model/sentence.dart';

class SampleTile extends StatelessWidget {
  final Lesson lesson;

  const SampleTile({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    // Lấy ra 5 câu Original Script
    List<Sentence> sentences5 =
        lesson.sentences.sublist(0, min(lesson.sentences.length, 5));
    List<String> originScript5 =
        sentences5.map((sentence) => sentence.originalScript).toList();

    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 7),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
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
          EllipsisText(
            originScript5,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}
