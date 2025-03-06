// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator  
// **************************************************************************

class LessonAdapter extends TypeAdapter<Lesson> {
  @override
  final int typeId = 0;

  @override
  Lesson read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Lesson(
      name: fields[0] as String,
      audioPath: fields[1] as String,
      originalSource: fields[2] as String,
      translatedSource: fields[3] as String,
      sentences: (fields[4] as List).cast<Sentence>(),
    );
  }

  @override
  void write(BinaryWriter writer, Lesson obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.audioPath)
      ..writeByte(2)
      ..write(obj.originalSource)
      ..writeByte(3)
      ..write(obj.translatedSource)
      ..writeByte(4)
      ..write(obj.sentences);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SentenceAdapter extends TypeAdapter<Sentence> {
  @override
  final int typeId = 1;

  @override
  Sentence read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sentence(
      originalScript: fields[0] as String,
      translatedScript: fields[1] as String,
      startTime: (fields[2] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Sentence obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.originalScript)
      ..writeByte(1)
      ..write(obj.translatedScript)
      ..writeByte(2)
      ..write(obj.startTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SentenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
