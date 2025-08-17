import 'dart:async';
import 'dart:io';
import 'package:mobile/src/core/audio/repo/audio_repo.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:mobile/src/core/api/enums/error_code.dart';
import 'package:mobile/src/core/api/models/api_failure.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioServiceProvider extends ChangeNotifier {
  AudioServiceProvider() {
    // AudioUtils.clearRecordingsFolder();
  }

  String? _transcription;
  String? get transcription => _transcription;
  set transcription(String? value) {
    _transcription = value;
    notifyListeners();
  }

  // Amplitude stream for sharing amplitude data
  final StreamController<double> _amplitudeController =
      StreamController<double>.broadcast();
  Stream<double> get amplitudeStream => _amplitudeController.stream;

  final AudioRecorder _audioRecorder = AudioRecorder();

  StreamSubscription<Amplitude>? _amplitudeSubscription;
  StreamSubscription<Amplitude>? get amplitudeSubscription =>
      _amplitudeSubscription;
  set amplitudeSubscription(StreamSubscription<Amplitude>? value) {
    _amplitudeSubscription = value;
    notifyListeners();
  }

  bool _isRecording = false;
  bool get isRecording => _isRecording;
  set isRecording(bool value) {
    _isRecording = value;
    notifyListeners();
  }

  File? _audioFile;
  File? get audioFile => _audioFile;
  set audioFile(File? value) {
    _audioFile = value;
    notifyListeners();
  }

  bool _isTranscribing = false;
  bool get isTranscribing => _isTranscribing;
  set isTranscribing(bool value) {
    _isTranscribing = value;
    notifyListeners();
  }

  Future<void> startRecording() async {
    final hasPermission = await _audioRecorder.hasPermission();

    if (!hasPermission) return;

    final dir = await getApplicationDocumentsDirectory();
    final recordingsDir = Directory("${dir.path}/recordings");

    // Ensure the recordings directory exists
    if (!await recordingsDir.exists()) {
      await recordingsDir.create(recursive: true);
    }

    final filePath = path.join(
      "${dir.path}/recordings",
      'audio_recording_${DateTime.now().millisecondsSinceEpoch}.m4a',
    );

    await _audioRecorder.start(
      RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
        numChannels: 1,
      ),
      path: filePath,
    );

    // Set recording state to true
    isRecording = true;

    amplitudeSubscription = _audioRecorder
        .onAmplitudeChanged(Duration(milliseconds: 100))
        .listen((amp) async {
          // Broadcast amplitude to any listeners (like waveform)
          _amplitudeController.add(amp.current);
        });
  }

  Future<void> stopRecording() async {
    if (!_isRecording) {
      return;
    }

    amplitudeSubscription?.cancel();
    amplitudeSubscription = null;
    isRecording = false;

    final filePath = await _audioRecorder.stop();

    if (filePath != null) {
      audioFile = File(filePath);
    }
  }

  Future<ApiFailure?> transcribe() async {
    if (isTranscribing) {
      return ApiFailure.fromErrorCode(
        errorType: ErrorCode.unknownError,
        message: "Already transcribing",
      );
    }

    isTranscribing = true;

    if (audioFile == null) {
      isTranscribing = false;
      return ApiFailure(
        code: ErrorCode.unknownError.id,
        message: "No audio file found",
      );
    }

    if (audioFile != null) {
      final (result, error) = await AudioRepo.uploadAudioFile(audioFile!);

      if (error != null) {
        isTranscribing = false;
        return error;
      }

      if (result == null) {
        isTranscribing = false;
        return ApiFailure(
          code: ErrorCode.unknownError.id,
          message: "No transcription result",
        );
      }

      transcription = result.transcription;
      audioFile = null;
      isTranscribing = false;

      reset();

      return null;
    }

    return ApiFailure(
      code: ErrorCode.unknownError.id,
      message: "No audio file found",
    );
  }

  void reset() {
    _audioFile = null;
    amplitudeSubscription?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    amplitudeSubscription?.cancel();
    _audioRecorder.dispose();
    _audioFile = null;
    _transcription = null;
    _amplitudeController.close();
    super.dispose();
  }
}
