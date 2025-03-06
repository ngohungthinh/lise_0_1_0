import 'dart:io';
import 'package:lise_0_1_0/common/reference.dart';

//-----------------------TIME---------------------------

// Convert duration into min:sec
String formatTime(Duration duration) {
  String twoDitgitSeconds =
      duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  String formattedTime = "${duration.inMinutes}:$twoDitgitSeconds";

  return formattedTime;
}

// Convert List time [00:00.0] to milisecond
int toMilisecond(List<int> times) {
  int seconds = (times[0] * 10 + times[1]) * 60 + (times[2] * 10 + times[3]);
  int miliSec = seconds * 1000 + times[4] * 100;
  return miliSec;
}

// Convert milisecond into List time [00:00.0]
List<int> milisecToListTime(int milisecond) {
  int miliSec = (milisecond % 1000) ~/ 100;
  int sec = (milisecond ~/ 1000) % 60;
  int min = (milisecond ~/ 1000) ~/ 60;

  return [min ~/ 10, min % 10, sec ~/ 10, sec % 10, miliSec];
}

//-----------------------FILE---------------------------

// Save file permanent. Đường dẫn audio sẽ là: /audio/432432432/name_audio.
Future<File> saveFilePermanently(String pathFile) async {
  // Get name file
  String fileName = pathFile.substring(pathFile.lastIndexOf('/') + 1);
  // Create a unique directory path
  final uniqueName = "${DateTime.now().millisecondsSinceEpoch}";
  final newDirectoryPath = "${directoryApp.path}/audio/$uniqueName";

  // Ensure the directory exists
  final newDirectory = Directory(newDirectoryPath);
  if (!newDirectory.existsSync()) {
    await newDirectory.create(recursive: true);
  }

  // Create the new file path
  final newPath = "$newDirectoryPath/$fileName";

  return File(pathFile).copy(newPath);
}

// Function to delete a file
Future<void> deleteFile(String filePath) async {
  try {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
      print("File deleted: $filePath");
    } else {
      print("File does not exist: $filePath");
    }
  } catch (e) {
    print("Error deleting file: $e");
  }
}

// Xóa file audio. do đường dẫn, nên phải xóa luôn cả ParentFolder
// Đường dẫn audio sẽ là: /audio/432432432/name_audio.
Future<void> deleteFileAndParentFolder(String filePath) async {
  try {
    final file = File(filePath);

    // Check if the file exists
    if (await file.exists()) {
      // Get the parent directory
      final parentDirectory = file.parent;

      // Delete the entire parent directory
      if (await parentDirectory.exists()) {
        await parentDirectory.delete(recursive: true);
        print("File and its parent directory deleted successfully.");
      } else {
        print("Parent directory does not exist.");
      }
    } else {
      print("File does not exist.");
    }
  } catch (e) {
    print("An error occurred while deleting the file and its folder: $e");
  }
}
