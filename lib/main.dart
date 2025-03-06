import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:lise_0_1_0/common/first_lanch_app.dart';
import 'package:lise_0_1_0/common/other.dart';
import 'package:lise_0_1_0/common/reference.dart';
import 'package:lise_0_1_0/common/theme.dart';
import 'package:lise_0_1_0/pages/home/home_page.dart';
import 'package:lise_0_1_0/hive/hive_registrar.g.dart';
import 'package:lise_0_1_0/model/lesson.dart';
import 'package:lise_0_1_0/provider/audio_provider.dart';
import 'package:lise_0_1_0/provider/play_list_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi chạy Hive
  await Hive.initFlutter();
  Hive.registerAdapters();

  // Get Reference thường dùng.
  sampleLessonBox = await Hive.openBox<Lesson>('sampleLesson');
  lessonBox = await Hive.openBox<Lesson>('lesson');
  directoryApp = await getApplicationDocumentsDirectory();

  // Nếu lần đầu runApp. Hàm này sẽ tải dữ liệu.
  await firstRunApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PlayListProvider()),
        ChangeNotifierProvider(create: (context) => AudioProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        scrollBehavior: NoGlowScrollBehavior(),
        home: const HomePage(),
      ),
    );
  }
}
