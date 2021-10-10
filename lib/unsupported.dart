import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:image_picker/image_picker.dart';
import 'interface.dart' as _interface;

class MediaRecorderHelper extends _interface.IMediaRecorderHelper {
  @override
  final MultiPartyRecorder recorder;
  MediaRecorderHelper(this.recorder);
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
