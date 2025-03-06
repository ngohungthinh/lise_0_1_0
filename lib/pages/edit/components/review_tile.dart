import 'package:flutter/material.dart';
import 'package:lise_0_1_0/common/function.dart';
import 'package:lise_0_1_0/pages/edit/function/edit_sentence.dart';
import 'package:lise_0_1_0/model/sentence.dart';
import 'package:lise_0_1_0/provider/edit_provider.dart';
import 'package:provider/provider.dart';

class ReviewTile extends StatelessWidget {
  final Sentence sentence;

  const ReviewTile({super.key, required this.sentence});

  @override
  Widget build(BuildContext context) {
    bool isPlay = context.select<EditProvider, bool>(
        (provider) => provider.currentSentencePlay == sentence);
    return GestureDetector(
      onTap: () => context.read<EditProvider>().playSentence(sentence),
      onLongPressMoveUpdate: (details) {
        showPopupMenu(
            context, details.globalPosition.dx, details.globalPosition.dy);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Start time
            Text(
              formatTime(Duration(milliseconds: sentence.startTime)),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1,
                  color: isPlay ? Colors.white : Colors.black),
            ),
            // Original text
            Text(sentence.originalScript,
                style: TextStyle(
                    color: isPlay ? Colors.white : Colors.black,
                    fontSize: 20.5,
                    fontWeight: FontWeight.w700,
                    height: 1.3)),
            // Translated text
            Text(
              sentence.translatedScript,
              style: TextStyle(
                color: isPlay ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPopupMenu(BuildContext context, double x, double y) async {
    int? result = await showMenu(
      popUpAnimationStyle: AnimationStyle(
        curve: Curves.easeOutQuart,
        // duration: Duration(milliseconds: 1000)
      ),
      context: context,
      menuPadding: const EdgeInsets.all(0),
      color: Colors.white,
      position: RelativeRect.fromLTRB(
        x,
        y,
        MediaQuery.of(context).size.width - x,
        MediaQuery.of(context).size.height - y,
      ),
      items: [
        PopupMenuItem(
          value: 0,
          child: Text(
            "Edit",
            style: TextStyle(
                fontWeight: FontWeight.w300, color: Colors.grey.shade900),
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Text(
            "Delete",
            style: TextStyle(
                fontWeight: FontWeight.w300, color: Colors.grey.shade900),
          ),
        )
      ],
    );

    // Nếu là delete thì xóa sentence, còn edit thì show Dialog chỉnh sửa.
    if (result == 1) {
      // ignore: use_build_context_synchronously
      deleteSentence(context);
    } else if (result == 0) {
      // ignore: use_build_context_synchronously
      showDialogEdit(context, sentence);
    }
  }

  void deleteSentence(BuildContext context) {
    // Xóa sentence và show Snackbar Undo.
    EditProvider provider = context.read<EditProvider>();
    provider.deleteSentence(sentence);

    // Nếu trước đó có Snackbar đang hiện thì ẩn đi.
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: const Text("Deleted"),
        action: SnackBarAction(
            label: 'undo', onPressed: () => provider.addSentence(sentence)),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
