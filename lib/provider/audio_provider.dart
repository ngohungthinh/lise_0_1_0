import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lise_0_1_0/model/lesson.dart';

// Cấu hình cho Android
const androidOptions = AndroidExtractorOptions(
  constantBitrateSeekingEnabled: true, // Bật seek chính xác cho MP3 CBR
  mp3Flags: AndroidExtractorOptions
      .flagMp3EnableIndexSeeking, // Bật index-based seeking
);

// Cấu hình cho iOS/macOS
const darwinOptions = DarwinAssetOptions(
  preferPreciseDurationAndTiming: true, // Bật seek chính xác
);

class AudioProvider extends ChangeNotifier {
  final AudioPlayer player = AudioPlayer();

  double currentSpeed = 1;
  Duration currentDuration = Duration.zero;
  Duration totalDuration = Duration.zero;
  bool isPlaying = true;
  bool isCompleted = false;
  LoopMode isLoop = LoopMode.off;

  AudioProvider() {
    init();
  }

  // Get Stream to Dispose
  late StreamSubscription<Duration> positionStream;
  late StreamSubscription<Duration?> durationStream;
  late StreamSubscription<bool> playingStream;
  late StreamSubscription<ProcessingState> processingStateStream;
  late StreamSubscription<LoopMode> loopModeStream;

  Future<void> init() async {
    // lang nghe cac Stream Listen: Position, playing, .....
    positionStream = player.positionStream.listen((duration) {
      currentDuration = duration;
      notifyListeners();
    });
    durationStream = player.durationStream.listen((duration) {
      totalDuration = duration ?? Duration.zero;
      notifyListeners();
    });
    playingStream = player.playingStream.listen((isPlaying) {
      this.isPlaying = isPlaying;
      notifyListeners();
    });
    processingStateStream =
        player.processingStateStream.listen((processingState) {
      if (processingState == ProcessingState.completed) {
        isCompleted = true;
        notifyListeners();
      } else {
        isCompleted = false;
        notifyListeners();
      }
    });
    loopModeStream = player.loopModeStream.listen((loopMode) {
      isLoop = loopMode;
      notifyListeners();
    });
  }

  //--------------Fuction--------------
  Future<void> setSourcePlayer(Lesson lesson) async {
    // Tạo ProgressiveAudioSource với tùy chọn
    final audioSource = ProgressiveAudioSource(
      Uri.parse(lesson.audioPath),
      options: const ProgressiveAudioSourceOptions(
        androidExtractorOptions: androidOptions,
        darwinAssetOptions: darwinOptions,
      ),
    );

    try {
      // Explicitly load the audio source to fetch metadata
      await player.setAudioSource(audioSource);
      await player.seek(const Duration(minutes: 20));
      await player.seek(Duration.zero);
      player.play();
    } catch (e) {
      print("Lỗi set FilePath: $e");
    }
    // await player.setFilePath(lesson.audioPath);
  }

  void setSpeed(double speed) async {
    await player.setSpeed(speed);
    currentSpeed = speed;
    notifyListeners();
  }

  void seek5sForward() async {
    if (currentDuration.inSeconds < totalDuration.inSeconds) {
      await player.seek(Duration(
          seconds:
              min(totalDuration.inSeconds, currentDuration.inSeconds + 5)));
    }
  }

  void seek5sBackward() async {
    await player.seek(Duration(seconds: max(0, currentDuration.inSeconds - 5)));
  }

  void toggleLoop() {
    if (isLoop == LoopMode.off) {
      player.setLoopMode(LoopMode.one);
    } else {
      player.setLoopMode(LoopMode.off);
    }
  }

  //---------------dispose-------------------
  @override
  void dispose() {
    positionStream.cancel();
    durationStream.cancel();
    playingStream.cancel();
    processingStateStream.cancel();
    loopModeStream.cancel();
    player.dispose();
    super.dispose();
  }
}
