import 'package:flutter/material.dart';
import 'package:lise_0_1_0/pages/components/shadow_scrollable.dart';
import 'package:lise_0_1_0/pages/edit/components/show_sentence.dart';
import 'package:lise_0_1_0/pages/edit/components/one_sentence_tile.dart';
import 'package:lise_0_1_0/pages/edit/components/popup_sentence.dart';
import 'package:lise_0_1_0/pages/edit/components/source_text.dart';
import 'package:lise_0_1_0/model/sentence.dart';
import 'package:lise_0_1_0/provider/edit_provider.dart';
import 'package:provider/provider.dart';

class EditPanel extends StatefulWidget {
  final bool isOriginal;
  const EditPanel({super.key, required this.isOriginal});

  @override
  State<EditPanel> createState() => _EditPanelState();
}

class _EditPanelState extends State<EditPanel> {
  final GlobalKey keySourceText = GlobalKey();
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShowSentence(
          isOriginal: widget.isOriginal,
          panelContext: context,
        ),
        Expanded(child: SourceText(isOriginal: widget.isOriginal)),
      ],
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Column(
  //     children: [
  //       ShadowScrollable(
  //         scrollController: controller,
  //         colorShadow: Colors.grey,
  //         heightShadow: 10,
  //         child: SingleChildScrollView(
  //           controller: controller,
  //           child: Column(
  //             children: [
  //               // Lắng nghe độ dài của sentences. Có thay đổi thì update Listview.
  //               Selector<EditProvider, int>(
  //                   selector: (_, provider) => provider.lesson.sentences.length,
  //                   builder: (context, length, _) {
  //                     List<Sentence> sentences =
  //                         context.read<EditProvider>().lesson.sentences;
  //                     return ListView.builder(
  //                       clipBehavior: Clip.hardEdge,
  //                       physics: const NeverScrollableScrollPhysics(),
  //                       padding: const EdgeInsets.only(left: 14, right: 14),
  //                       shrinkWrap: true,
  //                       itemCount: length,
  //                       itemBuilder: (context, index) {
  //                         return Padding(
  //                           padding: const EdgeInsets.symmetric(vertical: 6),
  //                           child: OneSentenceTile(
  //                               sentence: sentences[index],
  //                               isOriginal: widget.isOriginal),
  //                         );
  //                       },
  //                     );
  //                   }),
  //               // Phần Source Text
  //               SourceText(key: keySourceText, isOriginal: widget.isOriginal),
  //             ],
  //           ),
  //         ),
  //       ),
  //       // Popup sentence vừa được add gần đây
  //       Positioned(
  //         top: -8,
  //         right: 0,
  //         left: 0,
  //         child: PopupSentence(
  //           isOriginal: widget.isOriginal,
  //           controller: controller,
  //           containerContext: context,
  //           keySourceText: keySourceText,
  //         ),
  //       )
  //     ],
  //   );
  // }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
