import 'package:flutter/material.dart';

class SourcePanel extends StatelessWidget {
  final bool isOriginal;
  final String? hintText;
  final TextEditingController controller;
  final FocusNode focusNode;

  const SourcePanel(
      {super.key, required this.controller, required this.focusNode, this.hintText, required this.isOriginal});

  @override
  Widget build(BuildContext context) {
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
      ),
      child: TextField(
        enableSuggestions: false,
        focusNode: focusNode,
        controller: controller,
        cursorWidth: 1,
        maxLines: null,
        decoration: InputDecoration(
          hintText: hintText,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(0),
          hintStyle: TextStyle(
              color: Colors.grey.shade500, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
