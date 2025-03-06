import 'package:flutter/material.dart';
import 'package:lise_0_1_0/pages/edit/components/one_sentence_tile.dart';
import 'package:lise_0_1_0/model/sentence.dart';
import 'package:lise_0_1_0/provider/edit_provider.dart';
import 'package:provider/provider.dart';

class PopupSentence extends StatefulWidget {
  final bool isOriginal;
  // Theo dõi vị trí scroll của source Text so với Container bao bên ngoài để hiện popUP
  final ScrollController controller;
  final BuildContext containerContext;
  final GlobalKey keySourceText;

  const PopupSentence(
      {super.key,
      required this.isOriginal,
      required this.controller,
      required this.containerContext,
      required this.keySourceText});

  @override
  State<PopupSentence> createState() => _PopupSentenceState();
}

class _PopupSentenceState extends State<PopupSentence> {
  double? maxHeightPopup;

  // Track để có hiện Popup và có hiện Sentence hay không?
  bool isOverLay = false;
  bool isPopupSentence = true;
  // Show full added sentence or show 1 câu thôi.
  bool isShowFull = false;

  void _handleControllerEvent() {
    if (widget.keySourceText.currentContext != null) {
      final RenderBox boxSourceText =
          widget.keySourceText.currentContext!.findRenderObject() as RenderBox;
      final offsetSource = boxSourceText.localToGlobal(Offset.zero);

      final RenderBox boxContainer =
          widget.containerContext.findRenderObject() as RenderBox;
      final Offset offset = boxContainer.globalToLocal(offsetSource);

      if (offset.dy < 0 && isOverLay == false) {
        if (mounted) {
          // Kiểm tra widget có còn trong widget tree
          setState(() {
            isOverLay = true;
          });
        }
      } else if (offset.dy > 0 && isOverLay == true) {
        if (mounted) {
          // Kiểm tra widget có còn trong widget tree
          setState(() {
            isOverLay = false;
          });
        }
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      maxHeightPopup = widget.containerContext.size!.height + 15;
    });

    super.initState();
    // Lắng nghe scroll để show Popup
    widget.controller.addListener(_handleControllerEvent);
  }

  @override
  void didUpdateWidget(covariant PopupSentence oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Lấy height Container bao bên ngoài.
  }

  @override
  Widget build(BuildContext context) {
    // Nếu length added Sentence == 0 hoặc isOverLay = false (Source text chưa tới) thì không show gì cả
    int length = context.select<EditProvider, int>(
      (provider) => provider.logSentences.length,
    );
    if (length == 0 || isOverLay == false) return const SizedBox();

    // Nếu khác 0 thì show
    final List<Sentence> sentences = context.read<EditProvider>().logSentences;

    // Không muốn show sentence để tiết kiệm không gian
    if (isPopupSentence == false) {
      return GestureDetector(
        onTap: changeIsPopupSentence,
        child: const Icon(
          Icons.keyboard_arrow_down,
          size: 28,
          color: Colors.white54,
        ),
      );
    }

    // Show SENTENCE

    return Stack(
      children: [
        AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isShowFull ? maxHeightPopup : null,
            padding: const EdgeInsets.only(left: 11, right: 11, top: 10),
            decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(8)),
            child: isShowFull
                ? showListSentence(sentences)
                : showOneSentence(sentences[length - 1])),

        // Nút ẩn Popup
        if (isShowFull == false)
          Positioned(
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: changeIsPopupSentence,
              child: Icon(
                Icons.close,
                size: 20,
                color: Colors.grey.shade200,
              ),
            ),
          ),
      ],
    );
  }

  void changeIsPopupSentence() {
    setState(() {
      isPopupSentence = !isPopupSentence;
    });
  }

  Widget showOneSentence(Sentence sentence) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Text
        OneSentenceTile(sentence: sentence, isOriginal: widget.isOriginal),
        Center(
          child: InkWell(
            onTap: () {
              setState(() {
                isShowFull = true;
              });
            },
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 21,
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
                    sentence: sentences[length - 1 - index],
                    isOriginal: widget.isOriginal),
              );
            },
          ),
        ),
        Center(
          child: InkResponse(
            onTap: () {
              setState(() {
                isShowFull = false;
              });
            },
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
}
