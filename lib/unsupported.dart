import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:image_picker/image_picker.dart';
import 'interface.dart' as _interface;

class MediaRecorderHelper extends _interface.IMediaRecorderHelper {
  @override
  MediaRecorder get recorder => throw UnimplementedError();
  @override
  String get mimeType => throw UnimplementedError();
  @override
  bool get isMediaRecordingSupported => throw UnimplementedError();

  @override
  Future<void> startVideoRecordingWithMediaRecorder(MediaStream mediaStream,
      {bool mirror = true}) async {
    throw UnimplementedError();
  }

  @override
  Future<PickedFile> stopVideoRecordingWithMediaRecorder() async {
    throw UnimplementedError();
  }
}

class MultipartyRecorderHelper
    extends _interface.IMultipartyMediaRecorderHelper {
  @override
  final MultiPartyRecorder recorder;
  MultipartyRecorderHelper(this.recorder);
  @override
  String get mimeType => throw UnimplementedError();
  @override
  bool get isMediaRecordingSupported => throw UnimplementedError();

  @override
  Future<void> startRecorder() async {
    throw UnimplementedError();
  }

  @override
  Future<PickedFile> stopRecorder() async {
    throw UnimplementedError();
  }
}
