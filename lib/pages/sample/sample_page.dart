import 'package:flutter/material.dart';
import 'package:lise_0_1_0/pages/sample/sample_tile.dart';
import 'package:lise_0_1_0/model/lesson.dart';
import 'package:lise_0_1_0/provider/play_list_provider.dart';
import 'package:provider/provider.dart';

class SamplePage extends StatelessWidget {
  const SamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sample lesson"),
        shadowColor: Colors.grey.shade50,
        scrolledUnderElevation: 1.5,
      ),
      body: SafeArea(
        child: GlowingOverscrollIndicator(
          // showLeading: false,
          axisDirection: AxisDirection.down,
          color: Colors.grey.shade300,
          child: Scrollbar(
            child: Selector<PlayListProvider, List<Lesson>>(
              selector: (_, provider) => provider.sampleLessons,
              builder: (context, sampleLessons, child) {
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 10, bottom: 50),
                  itemCount: sampleLessons.length,
                  itemBuilder: (context, index) => SampleTile(
                    lesson: sampleLessons[index],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
