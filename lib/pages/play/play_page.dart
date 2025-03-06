import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lise_0_1_0/common/function.dart';
import 'package:lise_0_1_0/pages/components/player.dart';
import 'package:lise_0_1_0/pages/components/shadow_scrollable.dart';
import 'package:lise_0_1_0/pages/components/time_picker.dart';
import 'package:lise_0_1_0/pages/play/component/play_tile.dart';
import 'package:lise_0_1_0/model/lesson.dart';
import 'package:lise_0_1_0/model/sentence.dart';
import 'package:lise_0_1_0/pages/practice/practice_page.dart';
import 'package:lise_0_1_0/provider/play_provider.dart';
import 'package:lise_0_1_0/provider/practice_provider.dart';
import 'package:provider/provider.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  // Lesson
  late final Lesson lesson;
  late PlayProvider playProvider;

  // -------------Hệ thống tự Scroll theo SentencePlay-------------

  // Theo dõi sentencePlay có thay đổi không để update Scroll Position
  Sentence? sentencePlay;

  // Keys to track item positions.
  final Map<Sentence, GlobalKey> _itemKeys = {};

  // Check nếu user đang drag thì không update Scroll Position
  bool isDrag = false;

  // control scroll ListView
  final ScrollController _scrollController = ScrollController();

  void updateScroll() {
    PlayProvider provider = context.read<PlayProvider>();
    if (sentencePlay != provider.currentSentencePlay && isDrag == false) {
      sentencePlay = provider.currentSentencePlay;
      // Delay 100ms để khi lỡ có Tap xảy ra thì nó sẽ ẩn sub câu Tab trước đó. Rồi mới lấy vị trí của câu play
      Future.delayed(const Duration(milliseconds: 100),
          () => _scrollToCurrentSentence(sentencePlay));
    }
  }

  // 56 appbar, 8 20 la margin va padding
  late final double posListView =
      MediaQuery.of(context).padding.top + 56 + 8 + 20;
  void _scrollToCurrentSentence(Sentence? sentence) {
    final key = _itemKeys[sentence];
    if (key != null) {
      // print("Key khac null");
      final context = key.currentContext;
      if (context != null) {
        // print("Context khac null");
        // Get the offset of the item
        final RenderBox box = context.findRenderObject() as RenderBox;
        final offset = box.localToGlobal(Offset.zero, ancestor: null);

        // print(offset.dy);

        // Scroll to ensure the item is visible
        // Lấy ra vị trí của phần từ so với ListView. Sau đó cộng với vị trí scroll hiện tại.
        // Chi cuon khi vi tri cau duoi nua man hinh
        if (offset.dy > MediaQuery.of(context).size.height / 2) {
          double posSentence = offset.dy - posListView;
          _scrollController.animateTo(
            _scrollController.offset + (posSentence),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
          );
        }
      }
    }
  }

  // -------------Hệ thống tự Scroll theo SentencePlay-------------

  @override
  void initState() {
    super.initState();

    playProvider = context.read<PlayProvider>();
    lesson = playProvider.currentLesson;

    playProvider.addListener(updateScroll);

    // Initialize GlobalKeys for each sentence để track vị trí
    for (int i = 0; i < lesson.sentences.length; i++) {
      _itemKeys[lesson.sentences[i]] = GlobalKey();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Selector<PlayProvider, bool>(
          selector: (_, provider) =>
              provider.isShowCustomTimer || !provider.isOriginalTime,
          builder: (_, value, __) => !value
              ? Text(
                  lesson.name,
                )
              : Column(
                  children: [
                    Text(
                      lesson.name,
                      style: const TextStyle(fontSize: 13),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 2),
                        Selector<PlayProvider, String>(
                          selector: (_, provider) =>
                              "${formatTime(playProvider.timeStart)} - ${formatTime(playProvider.timeEnd)}",
                          builder: (_, value, __) => Text(value),
                        ),
                        const SizedBox(width: 2),
                        Selector<PlayProvider, bool>(
                          selector: (_, provider) => provider.isOriginalTime,
                          builder: (_, value, __) => value
                              ? const SizedBox()
                              : InkWell(
                                  onTap: playProvider.resetCustomTime,
                                  child: const Icon(
                                    Icons.highlight_remove_rounded,
                                    size: 20,
                                    color: Color.fromARGB(255, 233, 56, 115),
                                  ),
                                ),
                        )
                      ],
                    ),
                  ],
                ),
        ),
        actions: [
          Selector<PlayProvider, bool>(
            selector: (_, provider) => provider.isShowCustomTimer,
            builder: (_, value, __) => value
                ? IconButton(
                    onPressed: () => playProvider.changeShowCustomTimer(),
                    icon: const Icon(
                      Icons.keyboard_arrow_up_rounded,
                      size: 40,
                    ))
                : PopupMenuButton(
                    popUpAnimationStyle: AnimationStyle.noAnimation,
                    onSelected: (value) {
                      if (value == "timer") {
                        playProvider.changeShowCustomTimer();
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                            create: (context) => PracticeProvider(
                                lesson: playProvider.currentLesson,
                                player: playProvider.player),
                            child: const PracticePage(),
                          ),
                        ),
                      );
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "timer",
                        child: Text("Timer"),
                      ),
                      const PopupMenuItem(
                        value: "practice",
                        child: Text("Practice"),
                      ),
                    ],
                  ),
          )

          // TextButton(
          //   onPressed: () {
          //     playProvider.changeShowCustomTimer();
          //   },
          //   child: Row(
          //     children: [
          //       const Text("Timer"),
          //       Selector<PlayProvider, bool>(
          //         selector: (_, provider) => provider.isShowCustomTimer,
          //         builder: (_, value, __) => Icon(value
          //             ? Icons.keyboard_arrow_up_rounded
          //             : Icons.keyboard_arrow_down_rounded),
          //       )
          //     ],
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: const Player(),
      body: Column(
        children: [
          Selector<PlayProvider, bool>(
            selector: (_, provider) => provider.isShowCustomTimer,
            builder: (_, value, __) => value
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TimePicker(
                          time: playProvider.pickTimeStart,
                          reactItemChange: playProvider.reactCustomTime,
                        ),
                        IconButton(
                          onPressed: () {
                            playProvider.applyCustomTime();
                          },
                          icon: const Icon(Icons.volume_up_outlined),
                        ),
                        TimePicker(
                            time: context.read<PlayProvider>().pickTimeEnd,
                            reactItemChange: playProvider.reactCustomTime),
                      ],
                    ),
                  )
                : const SizedBox(),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.teal.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              // Kiểm tra user có đang cuộn hay không?
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is UserScrollNotification) {
                    if (notification.direction == ScrollDirection.idle) {
                      // User dừng cuộn
                      isDrag = false;
                    } else {
                      // User đang cuộn
                      isDrag = true;
                    }
                  }
                  return true;
                },
                child: ShadowScrollable(
                  scrollController: _scrollController,
                  colorShadow: Colors.teal.shade300,
                  heightShadow: 30,
                  child: ListView(
                    controller: _scrollController,
                    padding:
                        const EdgeInsets.only(bottom: 70, left: 20, right: 20),
                    children: List.generate(
                      lesson.sentences.length,
                      (index) => PlayTile(
                        key: _itemKeys[lesson.sentences[index]],
                        sentence: lesson.sentences[index],
                        indexSentence: index,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
