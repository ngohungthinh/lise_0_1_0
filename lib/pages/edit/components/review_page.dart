import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lise_0_1_0/common/function.dart';
import 'package:lise_0_1_0/pages/edit/components/review_tile.dart';
import 'package:lise_0_1_0/model/sentence.dart';
import 'package:lise_0_1_0/provider/edit_provider.dart';
import 'package:lise_0_1_0/provider/play_list_provider.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar(context),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 30, 133, 151),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Selector<EditProvider, int>(
          selector: (_, provider) => provider.lesson.sentences.length,
          builder: (_, length, __) {
            List<Sentence> sentences =
                context.read<EditProvider>().lesson.sentences;
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 70, top: 15),
              itemCount: length,
              itemBuilder: (context, index) =>
                  ReviewTile(sentence: sentences[index]),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    EditProvider editProvider = context.read<EditProvider>();
    return AppBar(
      leading: IconButton(
        onPressed: () async {
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
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          }
        },
        icon: const Icon(Icons.arrow_back),
      ),
      // Edit title
      title: InkWell(
        onTap: () {
          editLessonNameAndAudio(context);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Selector<EditProvider, String>(
                selector: (_, provider) => provider.lesson.name,
                builder: (_, name, __) {
                  return Text(name);
                },
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            const Icon(
              Icons.edit,
              size: 20,
              color: Colors.lightBlue,
            )
          ],
        ),
      ),
      // Button save, update
      actions: [
        editProvider.isUpdateLesson
            ? TextButton(
                onPressed: () => updateLesson(context),
                child: const Text(
                  "Update",
                  style: TextStyle(fontSize: 14),
                ))
            : TextButton(
                onPressed: () => saveLesson(context),
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 14),
                ))
      ],
    );
  }

  void saveLesson(BuildContext context) {
    EditProvider editProvider = context.read<EditProvider>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm save"),
        content: Text(
          "Save new lesson?",
          style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              // Lưu audio lại vĩnh viễn và update audio của lesson
              final fileSave =
                  await saveFilePermanently(editProvider.lesson.audioPath);
              editProvider.lesson.audioPath = fileSave.path;

              // Thêm vào Danh sách listen ở Hive.
              context.read<PlayListProvider>().addLesson(editProvider.lesson);

              Navigator.popUntil(
                context,
                (route) => route.isFirst,
              );
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  void updateLesson(BuildContext context) {
    EditProvider editProvider = context.read<EditProvider>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm update"),
        content: Text(
          "Update this lesson with changes?",
          style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<PlayListProvider>().updateLesson(
                  lesson: editProvider.originalLesson!,
                  newLesson: editProvider.lesson);

              Navigator.popUntil(
                context,
                (route) => route.isFirst,
              );
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  void editLessonNameAndAudio(BuildContext context) async {
    //Một vài biến để quản lý
    final EditProvider provider = context.read<EditProvider>();
    String audioPath = provider.lesson.audioPath;
    String nameFileAudioPick =
        audioPath.substring(audioPath.lastIndexOf('/') + 1);

    //---------------
    final TextEditingController nameLessonController = TextEditingController();
    nameLessonController.text = provider.lesson.name;

    final FocusNode focusNode = FocusNode();

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
              title: const Center(child: Text("Edit lesson")),
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
                        if (result != null &&
                            result.files.single.path != null) {
                          String catchFilePath =
                              result.files.single.path!; // Đường dẫn catch.

                          // Extract the file name using String methods
                          String fileName = catchFilePath
                              .substring(catchFilePath.lastIndexOf('/') + 1);

                          setState(() {
                            nameFileAudioPick = fileName;
                            audioPath = catchFilePath;
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
                        nameFileAudioPick,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              // Button cancel and Update
              actions: [
                Row(
                  children: [
                    // Button Cancel
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

                    // Button Update
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (nameLessonController.text.trim().isEmpty) {
                            // Show snackbar
                            Fluttertoast.showToast(
                                msg: "Enter lesson name",
                                backgroundColor: Colors.lightBlue,
                                gravity: ToastGravity.TOP);
                            return;
                          }

                          // Update name
                          provider.updateName(nameLessonController.text.trim());
                          provider.updateAudio(audioPath);

                          Navigator.pop(context);
                        },
                        child: const Center(
                          child: Text("Update"),
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
