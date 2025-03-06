import 'package:flutter/material.dart';
import 'package:lise_0_1_0/model/sentence.dart';
import 'package:lise_0_1_0/pages/edit/components/one_sentence_tile.dart';
import 'package:lise_0_1_0/provider/edit_provider.dart';
import 'package:provider/provider.dart';

class ShowSentence extends StatefulWidget {
  final bool isOriginal;
  final BuildContext panelContext;
  const ShowSentence(
      {super.key, required this.isOriginal, required this.panelContext});

  @override
  State<ShowSentence> createState() => _ShowSentenceState();
}

class _ShowSentenceState extends State<ShowSentence> {
  double? maxHeight;

  // Track có hiện sentences hay không?
  bool isShowSentence = true;
  // Show full added sentence or show 1 câu thôi.
  bool isShowFull = false;
  // Show log hay show sentences bình thường.
  bool isShowLog = false;

  @override
  void initState() {
    //addPostFrameCallback schedules a callback that will run after the current frame has been built and laid out.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      maxHeight = widget.panelContext.size!.height;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int length = context.select<EditProvider, int>(
      (provider) => provider.lesson.sentences.length,
    );

    // Nếu length added Sentence == 0  thì không show gì cả
    if (length == 0) return const SizedBox(height: 8);

    // Khi != 0 thì show sentence.
    final List<Sentence> logSentences =
        context.read<EditProvider>().logSentences;
    final List<Sentence> sentences =
        context.read<EditProvider>().lesson.sentences;

    // Không muốn show sentence để tiết kiệm không gian
    if (isShowSentence == false) {
      return SizedBox(
        child: GestureDetector(
          onTap: changeIsShowSentence,
          child: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white54,
          ),
        ),
      );
    }

    return Stack(
      children: [
        AnimatedContainer(
          constraints: isShowFull == false && maxHeight != null
              ? BoxConstraints(maxHeight: maxHeight! / 2)
              : null,
          duration: const Duration(milliseconds: 300),
          height: isShowFull ? maxHeight : null,
          padding: const EdgeInsets.only(left: 11, right: 11, top: 22),
          decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(8)),
          child: isShowFull
              ? showListSentence(isShowLog ? logSentences : sentences)
              : showOneSentence(isShowLog ? logSentences : sentences),
        ),
        Positioned(
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: changeIsShowSentence,
            child: Icon(
              Icons.close,
              color: Colors.grey.shade200,
            ),
          ),
        ),
        Positioned(
          right: 10,
          child: GestureDetector(
            onTap: changeIsShowLog,
            child: isShowLog
                ? Icon(
                    Icons.arrow_back_sharp,
                    color: Colors.grey.shade200,
                  )
                : const Text(
                    "Log",
                    style: TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0,
                    ),
                  ),
          ),
        )
      ],
    );
  }

  Widget showOneSentence(List<Sentence> sentences) {
    int length = sentences.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Nếu không có câu nào để show. Thì ghi No Log
        length > 0
            ?
            // Text
            Flexible(
                child: SingleChildScrollView(
                  child: OneSentenceTile(
                      sentence: sentences[length - 1],
                      isOriginal: widget.isOriginal),
                ),
              )
            : Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "No log",
                      style: TextStyle(
                          color: Colors.yellow.shade600, fontSize: 17),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),

        // Button expand sentence
        Center(
          child: InkWell(
            onTap: changeIsShowFull,
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey.shade200,
            ),
          ),
        ),
      ],
    );
  }

  Widget showListSentence(List<Sentence> sentences) {
    int length = sentences.length;
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: OneSentenceTile(
                    sentence: sentences[index], isOriginal: widget.isOriginal),
              );
            },
          ),
        ),
        Center(
          child: InkResponse(
            onTap: changeIsShowFull,
            child: Icon(
              Icons.keyboard_arrow_up,
              size: 30,
              color: Colors.grey.shade200,
            ),
          ),
        ),
      ],
    );
  }

  void changeIsShowSentence() {
    setState(() {
      isShowSentence = !isShowSentence;
    });
  }

  void changeIsShowFull() {
    setState(() {
      isShowFull = !isShowFull;
    });
  }

  void changeIsShowLog() {
    setState(() {
      isShowLog = !isShowLog;
    });
  }
}
