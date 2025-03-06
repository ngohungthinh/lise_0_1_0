import 'package:flutter/material.dart';
import 'package:lise_0_1_0/common/function.dart';
import 'package:lise_0_1_0/pages/edit/function/edit_sentence.dart';
import 'package:lise_0_1_0/model/sentence.dart';
import 'package:lise_0_1_0/provider/edit_provider.dart';
import 'package:provider/provider.dart';

class OneSentenceTile extends StatelessWidget {
  final Sentence sentence;
  final bool isOriginal;
  const OneSentenceTile({
    super.key,
    required this.sentence,
    required this.isOriginal,
  });

  @override
  Widget build(BuildContext context) {
    bool isPlay = context.select<EditProvider, bool>(
        (provider) => sentence == provider.currentSentencePlay);
    return GestureDetector(
      onTap: () => context.read<EditProvider>().playSentence(sentence),
      onLongPressMoveUpdate: (details) {
        showPopupMenu(
            context, details.globalPosition.dx, details.globalPosition.dy);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            formatTime(Duration(milliseconds: sentence.startTime)),
            style: TextStyle(
                fontWeight: FontWeight.w400,
                height: 1,
                fontSize: 12,
                color: isPlay ? Colors.grey.shade100 : Colors.black),
          ),
          Text(
            isOriginal ? sentence.originalScript : sentence.translatedScript,
            style: TextStyle(
              height: 1.3,
              fontWeight: FontWeight.w500,
              color: isPlay ? Colors.grey.shade100 : Colors.black,
            ),
          ),
        ],
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
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 45),
        content: const Text("Deleted"),
        action: SnackBarAction(
            label: 'undo', onPressed: () => provider.addSentence(sentence)),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
