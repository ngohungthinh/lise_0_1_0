import 'package:flutter/material.dart';
import 'package:lise_0_1_0/pages/set_source/set_source_page.dart';
import 'package:lise_0_1_0/provider/edit_provider.dart';
import 'package:provider/provider.dart';

class SourceText extends StatelessWidget {
  final bool isOriginal;
  const SourceText({super.key, required this.isOriginal});

  @override
  Widget build(BuildContext context) {
    String source = context.select<EditProvider, String>((provider) =>
        isOriginal
            ? provider.lesson.originalSource
            : provider.lesson.translatedSource);
    return Padding(
      padding: const EdgeInsets.only(right: 14, left: 14, bottom: 8),
      child: ListView(
        children: [
          // Source text
          SelectableText(
            source,
            contextMenuBuilder: (context, editableTextState) {
              return const SizedBox.shrink();
            },
            style: const TextStyle(
                fontSize: 17,
                height: 1.3,
                color: Colors.white,
                fontWeight: FontWeight.w300),
            onSelectionChanged: (selection, cause) {
              if (isOriginal) {
                context.read<EditProvider>().originalSelection = selection;
              } else {
                context.read<EditProvider>().translatedSelection = selection;
              }
            },
          ),

          // Button edit source text
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => SetSourcePage(
                            editProvider: context.read<EditProvider>())));
              },
              child: const Text("Edit source text"),
            ),
          ),
        ],
      ),
    );
  }
}
