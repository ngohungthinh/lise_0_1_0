import 'package:flutter/material.dart';
import 'package:lise_0_1_0/pages/components/time_picker.dart';
import 'package:lise_0_1_0/provider/play_provider.dart';
import 'package:provider/provider.dart';

class AppBarPlayPage extends StatelessWidget implements PreferredSizeWidget {
  const AppBarPlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 34),
        child: Column(
          children: [
            Text(
              context.read<PlayProvider>().currentLesson.name,
              style: const TextStyle(fontSize: 13),
            ),
            const Row(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(
                //   Icons.highlight_remove_rounded,
                //   size: 18,
                //   color: Colors.transparent,
                // ),
                SizedBox(width: 2),
                Text(
                  "0:00 - 3:25",
                  // style: TextStyle(fontSize: 20),
                ),
                SizedBox(width: 2),
                // Icon(
                //   Icons.highlight_remove_rounded,
                //   size: 18,
                //   color: Colors.pink,
                // )
              ],
            ),
          ],
        ),
      ),
      actions: [
        SizedBox(
          width: 89,
          child: TextButton(
            onPressed: () {},
            child: const Row(
              children: [Text("Timer"), Icon(Icons.keyboard_arrow_up_rounded)],
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TimePicker(time: context.read<PlayProvider>().pickTimeStart),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.volume_up_outlined),
              ),
              TimePicker(time: context.read<PlayProvider>().pickTimeEnd),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 60);
}
