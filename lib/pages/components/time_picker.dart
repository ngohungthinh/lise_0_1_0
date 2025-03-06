import 'package:flutter/material.dart';

class TimePicker extends StatelessWidget {
  final List<int> time;
  final void Function()? reactItemChange;
  const TimePicker({
    super.key,
    required this.time,
    this.reactItemChange,
  });

  @override
  Widget build(BuildContext context) {
    final List<int> digit10 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    final List<int> digit6 = [0, 1, 2, 3, 4, 5];
    final tenMinController = FixedExtentScrollController(initialItem: time[0]);
    final minController = FixedExtentScrollController(initialItem: time[1]);
    final tenSecController = FixedExtentScrollController(initialItem: time[2]);
    final secController = FixedExtentScrollController(initialItem: time[3]);
    final miliSecController = FixedExtentScrollController(initialItem: time[4]);

    return Row(
      children: [
        // Minute
        buildCircularPicker(digit10, tenMinController, (value) {
          time[0] = value;
          if (reactItemChange != null) reactItemChange!();
        }),
        buildCircularPicker(digit10, minController, (value) {
          time[1] = value;
          if (reactItemChange != null) reactItemChange!();
        }),
        const Text(":", style: TextStyle(fontSize: 32, height: 1)),
        // Second
        buildCircularPicker(digit6, tenSecController, (value) {
          time[2] = value;
          if (reactItemChange != null) reactItemChange!();
        }),
        buildCircularPicker(digit10, secController, (value) {
          time[3] = value;
          if (reactItemChange != null) reactItemChange!();
        }),
        // Milisecond
        const Text(".",
            style: TextStyle(
              fontSize: 32,
            )),
        buildCircularPicker(digit10, miliSecController, (value) {
          time[4] = value;
        }),
      ],
    );
  }

  Widget buildCircularPicker(
      List<int> digits,
      FixedExtentScrollController controller,
      Function(int) onSelectedItemChanged) {
    return Container(
      width: 30,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 0.5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200, width: 2)),
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 40.0,
        diameterRatio: 1.5,
        physics: const FixedExtentScrollPhysics(),
        perspective: 0.004,
        onSelectedItemChanged: (index) {
          onSelectedItemChanged(index);
        },
        childDelegate: ListWheelChildLoopingListDelegate(
          children: digits
              .map(
                (digit) => Center(
                  child: Text(
                    digit.toString(),
                    style: TextStyle(fontSize: 24, color: Colors.grey.shade600),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
