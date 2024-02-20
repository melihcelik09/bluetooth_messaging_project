import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:bluetooth_messaging_project/app/views/chat/view/chat_view.dart';
import 'package:bluetooth_messaging_project/core/common/models/message_model.dart';
import 'package:bluetooth_messaging_project/core/enum/message_type.dart';
import 'package:bluetooth_messaging_project/core/extension/duration_extension.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

mixin ChatViewMixin on State<ChatView> {
  late StreamSubscription _receivedDataSubscription;
  List<MessageModel> messages = [];
  late TextEditingController controller;
  late AudioRecorder recorder;
  late StreamSubscription<Amplitude?> _amplitudeSubscription;
  final List<double> amplitudes = [];
  late AudioPlayer player;
  late Duration position;
  bool isRecording = false;
  bool isPlaying = false;
  String? audioPath;
  Duration? maxDuration;
  Timer? _timer;
  late Duration recordDuration;
  late ScrollController noiseController;
  Uint8List? audioBytes;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    noiseController = ScrollController();
    recorder = AudioRecorder();
    player = AudioPlayer();
    position = const Duration();
    recordDuration = const Duration();

    _amplitudeSubscription = recorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((amp) {
      setState(() {
        /// The line `double scaled = (1 - (amp.current.abs() / 50)).clamp(0.0, 100.0) * 100;` is
        /// calculating the scaled amplitude value based on the current amplitude value received from
        /// the microphone.
        double scaled = (1 - (amp.current.abs() / 50)).clamp(0.05, 100.0) * 100;
        amplitudes.add(scaled);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (noiseController.hasClients) {
            noiseController.animateTo(
              noiseController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      });
    });

    player.onDurationChanged.listen((event) {
      setState(() {
        maxDuration = event;
      });
    });
    player.onPositionChanged.listen((event) {
      if (event == maxDuration) {
        setState(() {
          isPlaying = false;
        });
      } else {
        setState(() {
          position = event;
        });
      }
    });
    _receivedDataSubscription = widget.service.dataReceivedSubscription(
      callback: (data) {
        MessageModel message = MessageModel(
          senderId: data["senderDeviceId"],
          content: data["message"],
          type: MessageType.receiver,
          isVoiceMessage: audioBytes != null,
        );
        setState(() {
          messages.add(message);
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _receivedDataSubscription.cancel();
    recorder.dispose();
    _amplitudeSubscription.cancel();
    player.dispose();
  }

  Future<void> recordAudio() async {
    try {
      if (await recorder.hasPermission()) {
        var appDirectory = await getApplicationDocumentsDirectory();
        await recorder.start(
          const RecordConfig(),
          path: "${appDirectory.path}/recording.m4a",
        );
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            recordDuration = recordDuration + const Duration(seconds: 1);
          });
        });
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      debugPrint("Recording Error: $e");
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await recorder.stop();
      _timer?.cancel();
      debugPrint("Record Path: $path");

      File file = File(path!);

      Uint8List bytes = await file.readAsBytes();

      setState(() {
        audioBytes = bytes;
      });

      setState(() {
        isRecording = false;
        audioPath = path;
      });
    } catch (e) {
      debugPrint("Stopping Record Error: $e");
    }
  }

  Future<void> playRecording() async {
    try {
      if (isPlaying) {
        await player.pause();
        setState(() {
          isPlaying = false;
        });
      } else {
        File file = File(audioPath!);
        if (await file.exists()) {
          DeviceFileSource local = DeviceFileSource(audioPath!);
          await player.play(local);
          setState(() {
            isPlaying = true;
          });
        } else {
          debugPrint("File not found");
        }
      }
    } catch (e) {
      debugPrint("Playing Record Error: $e");
    }
  }

  String getDuration() {
    if (isPlaying) {
      return position.format;
    } else {
      return recordDuration.format;
    }
  }
}
