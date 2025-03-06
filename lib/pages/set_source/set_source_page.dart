import 'package:flutter/material.dart';
import 'package:lise_0_1_0/model/lesson.dart';
import 'package:lise_0_1_0/pages/edit/edit_page.dart';
import 'package:lise_0_1_0/pages/set_source/source_panel.dart';
import 'package:lise_0_1_0/provider/audio_provider.dart';
import 'package:lise_0_1_0/provider/edit_provider.dart';
import 'package:provider/provider.dart';

class SetSourcePage extends StatefulWidget {
  // editProvicer != null là Ở EditPage gọi qua
  final Lesson? lesson;
  final EditProvider? editProvider;
  const SetSourcePage({super.key, this.lesson, this.editProvider});

  @override
  State<SetSourcePage> createState() => _SetSourcePageState();
}

class _SetSourcePageState extends State<SetSourcePage> {
  int originFlex = 1, translateFlex = 1;
  final FocusNode originFocusNode = FocusNode();
  final FocusNode translateFocusNode = FocusNode();
  final TextEditingController originController = TextEditingController();
  final TextEditingController translateController = TextEditingController();

  void _handleFocusChange() {
    if (originFocusNode.hasFocus && originFlex == 1) {
      setState(() {
        originFlex = 2;
        translateFlex = 1;
      });
    } else if (translateFocusNode.hasFocus && translateFlex == 1) {
      setState(() {
        originFlex = 1;
        translateFlex = 2;
      });
    }

    // Nếu không có cái nào focus
    if (!originFocusNode.hasFocus &&
        !translateFocusNode.hasFocus &&
        (originFlex == 2 || translateFlex == 2)) {
      setState(() {
        originFlex = 1;
        translateFlex = 1;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Add listeners to detect focus changes
    originFocusNode.addListener(_handleFocusChange);
    translateFocusNode.addListener(_handleFocusChange);

    // Ở trang EditPage gọi qua thì set Text trùng với Source có sẵn.
    if (widget.editProvider != null) {
      originController.text = widget.editProvider!.lesson.originalSource;
      translateController.text = widget.editProvider!.lesson.translatedSource;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        translateFocusNode.unfocus();
        originFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Source text"),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: originFlex,
              child: SourcePanel(
                isOriginal: true,
                controller: originController,
                focusNode: originFocusNode,
                hintText: "Original source text",
              ),
            ),
            const Icon(
              Icons.keyboard_double_arrow_down,
              color: Colors.grey,
            ),
            Expanded(
              flex: translateFlex,
              child: SourcePanel(
                isOriginal: false,
                controller: translateController,
                focusNode: translateFocusNode,
                hintText: "Translated source text",
              ),
            ),
            const SizedBox(height: 7)
          ],
        ),
        bottomNavigationBar:
            // Nếu là Edit thì hiện Button Update, Còn Add thì hiện Create
            Padding(
          padding: const EdgeInsets.only(left: 50, right: 50, bottom: 7),
          child: widget.editProvider != null
              ? ElevatedButton(
                  onPressed: () {
                    //Update source
                    widget.editProvider!.setSoutceText(
                        originController.text.trim(),
                        translateController.text.trim());

                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    child: Text("Update"),
                  ))
              : ElevatedButton(
                  onPressed: gotoEditPage,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    child: Text("Create"),
                  )),
        ),
      ),
    );
  }

  void gotoEditPage() {
    final Lesson lesson = widget.lesson!;
    lesson.originalSource = originController.text.trim();
    lesson.translatedSource = translateController.text.trim();

    // Set Audio và đi sang EditPage
    context.read<AudioProvider>().setSourcePlayer(lesson);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (context) => EditProvider(
                      lesson: lesson,
                      player: context.read<AudioProvider>().player),
                  child: const EditPage(),
                )),
        (route) => route.isFirst);
  }

  @override
  void dispose() {
    translateFocusNode.dispose();
    originFocusNode.dispose();
    super.dispose();
  }
}
