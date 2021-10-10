import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:image_picker/image_picker.dart';

typedef RecordComplete = void Function(PickedFile file);

class MediaRecorderError implements Exception {
  final String? message;
  final String? code;
  MediaRecorderError({this.code, this.message});
}

abstract class IMediaRecorderHelper {
  MultiPartyRecorder? get recorder;
  bool get isMediaRecordingSupported;
  String? get mimeType;
  Future<void> startRecorder();
  Future<PickedFile> stopRecorder();
}
