import 'package:flutter/material.dart';
import 'package:lise_0_1_0/provider/practice_provider.dart';
import 'package:provider/provider.dart';

class IndexCurrentWheel extends StatelessWidget {
  final ScrollController scrollController;
  const IndexCurrentWheel({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    PracticeProvider practiceProvider = context.read<PracticeProvider>();
    return Container(
      width: 100,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 0.5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200, width: 2)),
      child: ListWheelScrollView.useDelegate(
        controller: scrollController,
        itemExtent: 40.0,
        diameterRatio: 1.5,
        physics: const FixedExtentScrollPhysics(),
        perspective: 0.004,
        onSelectedItemChanged: (value) {
          practiceProvider.changeIndexCurrent(value);
        },
        childDelegate: ListWheelChildLoopingListDelegate(children: [
          for (int i = 1; i <= practiceProvider.lesson.sentences.length; i++)
            Center(
              child: Text(
                i.toString(),
                style: TextStyle(fontSize: 24, color: Colors.grey.shade600),
              ),
            ),
        ]),
      ),
    );
  }
}
