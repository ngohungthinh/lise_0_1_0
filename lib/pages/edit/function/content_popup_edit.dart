import 'package:flutter/material.dart';
import 'package:lise_0_1_0/pages/components/shadow_scrollable.dart';

class ContentPopupEdit extends StatefulWidget {
  final TextEditingController oriController;
  final TextEditingController tranController;
  const ContentPopupEdit(
      {super.key, required this.oriController, required this.tranController});

  @override
  State<ContentPopupEdit> createState() => _ContentPopupEditState();
}

class _ContentPopupEditState extends State<ContentPopupEdit>
    with WidgetsBindingObserver {
  final ScrollController oriScroll = ScrollController();
  final ScrollController tranScroll = ScrollController();
  //----------------------
  final FocusNode oriFocusNode = FocusNode();
  final FocusNode tranFocusNode = FocusNode();
  bool showOrigin = true;
  bool showTransla = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }

  // Khi mà Keyboard appear or disappear thì hàm này được gọi.
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = WidgetsBinding
        .instance.platformDispatcher.views.first.viewInsets.bottom;
    print(bottomInset);

    if (!mounted) return; // Ensure widget is still in the tree

    setState(() {
      if (bottomInset > 0) {
        if (oriFocusNode.hasFocus) {
          showTransla = false;
        } else {
          showOrigin = false;
        }
      }

      if (bottomInset == 0) {
        showTransla = true;
        showOrigin = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: showOrigin,
          child: Flexible(
            child: ShadowScrollable(
              scrollController: oriScroll,
              colorShadow: Colors.white,
              heightShadow: 20,
              timeCreateShadow: Durations.short3,
              child: TextField(
                controller: widget.oriController,
                scrollController: oriScroll,
                focusNode: oriFocusNode,
                enableSuggestions: false,
                maxLines: null,
                cursorWidth: 1,
                style: const TextStyle(fontSize: 18, color: Colors.black),
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    fillColor: Colors.transparent),
              ),
            ),
          ),
        ),
        Visibility(
          visible: showOrigin && showTransla,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 25),
            width: MediaQuery.of(context).size.width / 3,
            height: 2,
            color: Colors.lightBlue.shade100,
          ),
        ),
        Visibility(
          visible: showTransla,
          child: Flexible(
            child: ShadowScrollable(
              scrollController: tranScroll,
              colorShadow: Colors.white,
              heightShadow: 20,
              timeCreateShadow: Durations.short3,
              child: TextField(
                controller: widget.tranController,
                scrollController: tranScroll,
                focusNode: tranFocusNode,
                enableSuggestions: false,
                maxLines: null,
                cursorWidth: 1,
                style: TextStyle(fontSize: 18, color: Colors.blue.shade800),
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    fillColor: Colors.transparent),
              ),
            ),
          ),
        )
      ],
    );
  }
}
