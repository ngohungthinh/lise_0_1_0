import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lise_0_1_0/pages/home/components/lesson_tile.dart';
import 'package:lise_0_1_0/pages/home/components/lis_e_sample_tile.dart';
import 'package:lise_0_1_0/model/lesson.dart';
import 'package:lise_0_1_0/pages/set_source/set_source_page.dart';
import 'package:lise_0_1_0/provider/play_list_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    print("home build");
    return Scaffold(
      body: SafeArea(
        // Nhớ sửa Source GlowingOverscrollIndicator để chỉnh height
        // Dòng: final double height = math.min(size.height, size.width * 0.1);
        child: GlowingOverscrollIndicator(
          showLeading: false,
          axisDirection: AxisDirection.down,
          color: Colors.grey,
          child: Scrollbar(
            child: Consumer<PlayListProvider>(
              builder: (context, provider, child) {
                List<Lesson> lessons = provider.lessons;
                return ListView.builder(
                    padding: const EdgeInsets.only(top: 15, bottom: 50),
                    itemCount: lessons.length + 1,
                    itemBuilder: (context, index) {
                      // Xuất từ mới đến cũ. Riêng phần tử đầu show Logo
                      int i = lessons.length - index;
                      if (i == lessons.length) {
                        return const LisESampleTile();
                      }

                      return LessonTile(lesson: lessons[i]);
                    });
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addLesson(context);
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }

  void addLesson(BuildContext context) async {
    //Một vài biến để quản lý
    final FocusNode focusNode = FocusNode();
    final TextEditingController nameLessonController = TextEditingController();

    // đường dẫn file Audio và tên file audio
    String? nameFileAudioPick;
    String? catchPathFile;

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return GestureDetector(
            onTap: () => focusNode.unfocus(),
            child: AlertDialog(
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              // contentPadding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30),
              title: const Center(child: Text("Create lesson")),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width),
                      child: TextField(
                        enableSuggestions: false,
                        controller: nameLessonController,
                        focusNode: focusNode,
                        cursorWidth: 1,
                        style: TextStyle(
                            fontSize: 21, color: Colors.grey.shade900),
                        maxLines: null,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade50,
                          hintText: "Title",
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontSize: 21,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  OutlinedButton(
                    onPressed: () async {
                      try {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(type: FileType.audio);
                        if (result != null) {
                          // Open single file
                          final PlatformFile file = result.files.first;
                          setState(() {
                            nameFileAudioPick = file.name;
                            catchPathFile = file.path;
                          });
                        }
                      } catch (e) {
                        Fluttertoast.showToast(
                            msg: "Error!",
                            backgroundColor: Colors.lightBlue,
                            gravity: ToastGravity.TOP);
                      }
                    },
                    child: Center(
                      child: Text(
                        nameFileAudioPick ?? "Select audio",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Center(
                          child: Text("Cancel"),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (nameFileAudioPick == null ||
                              nameLessonController.text.trim().isEmpty) {
                            // Show snackbar
                            Fluttertoast.showToast(
                                msg: "Enter lesson name and select audio file",
                                backgroundColor: Colors.lightBlue,
                                gravity: ToastGravity.TOP);

                            return;
                          }

                          Lesson newLesson = Lesson(
                              name: nameLessonController.text.trim(),
                              audioPath: catchPathFile!,
                              originalSource: "",
                              translatedSource: "",
                              sentences: []);

                          Navigator.push(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SetSourcePage(lesson: newLesson),
                            ),
                          );
                        },
                        child: const Center(
                          child: Text("Next"),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
      },
    );

    // Dispose of the controllers after the dialog is dismissed
    nameLessonController.dispose();
    focusNode.dispose();
  }
}
