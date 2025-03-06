import 'package:flutter/material.dart';
import 'package:lise_0_1_0/pages/components/player.dart';
import 'package:lise_0_1_0/pages/edit/components/edit_sentence_page.dart';
import 'package:lise_0_1_0/pages/edit/components/review_page.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return popScreen(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: const Player(),
        body: TabBarView(
          controller: _tabController,
          children: const [EditSentencePage(), ReviewPage()],
        ),
      ),
    );
  }

  Widget popScreen({required Scaffold child}) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final bool? shouldLeave = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit without saving'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel')),
            ],
          ),
        );

        // Control navigation based on the dialog result
        if (shouldLeave == true) {
          // Allow navigation
          Navigator.pop(context);
        }
      },
      child: child,
    );
  }
}
