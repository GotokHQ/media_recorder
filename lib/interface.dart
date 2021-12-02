import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:image_picker/image_picker.dart';

typedef RecordComplete = void Function(XFile file);

class MediaRecorderError implements Exception {
  final String? message;
  final String? code;
  MediaRecorderError({this.code, this.message});
}

abstract class IMultipartyMediaRecorderHelper {
  MultiPartyRecorder? get recorder;
  bool get isMediaRecordingSupported;
  String? get mimeType;
  Future<void> startRecorder();
  Future<XFile> stopRecorder();
}

abstract class IMediaRecorderHelper {
  MediaRecorder? get recorder;
  bool get isMediaRecordingSupported;
  String? get mimeType;
  Future<void> startVideoRecordingWithMediaRecorder(MediaStream mediaStream,
      {bool mirror = true});
  Future<XFile> stopVideoRecordingWithMediaRecorder();
}
