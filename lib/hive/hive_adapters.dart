import "package:hive_ce/hive.dart";
import "package:lise_0_1_0/model/lesson.dart";
import "package:lise_0_1_0/model/sentence.dart";

part 'hive_adapters.g.dart';

@GenerateAdapters([AdapterSpec<Lesson>(), AdapterSpec<Sentence>()])
void _() {}
