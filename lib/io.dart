import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart'
    show MultiPartyRecorder, MediaRecorder, MediaStream;
import 'package:image_picker/image_picker.dart';
import 'package:universal_platform/universal_platform.dart';
import 'interface.dart' as _interface;

class MediaRecorderHelper extends _interface.IMediaRecorderHelper {
  MediaRecorder? _recorder;
  late String _path;
  @override
  bool get isMediaRecordingSupported => true;
  @override
  MediaRecorder? get recorder => _recorder;
  @override
  String get mimeType => 'video/mp4';

  @override
  Future<void> startVideoRecordingWithMediaRecorder(MediaStream mediaStream,
      {bool mirror = true}) async {
    final Directory extDir = await getTemporaryDirectory();
    final String dirPath = '${extDir.path}/gotok/recordings';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/1min.mp4';
    final file = File(filePath);
    final bool exists = await file.exists();
    if (exists) {
      await file.delete();
    }
    try {
      _recorder?.stop();
      _recorder = MediaRecorder();
      _path = filePath;
      _recorder!.start(
        _path,
        videoTrack: mediaStream.getVideoTracks().first,
      );
    } catch (e) {
      _recorder?.stop();
      _recorder = null;
      throw _interface.MediaRecorderError(message: e.toString());
    }
  }

  @override
  Future<XFile> stopVideoRecordingWithMediaRecorder() async {
    try {
      await _recorder?.stop();
      _recorder = null;
      return XFile(_path, mimeType: 'video/mp4');
    } catch (e) {
      return throw _interface.MediaRecorderError(message: e.toString());
    } finally {
      _recorder?.stop();
      _recorder = null;
    }
  }
}

class MultipartyRecorderHelper
    extends _interface.IMultipartyMediaRecorderHelper {
  @override
  final MultiPartyRecorder recorder;

  MultipartyRecorderHelper(this.recorder);

  late String _path;
  @override
  bool get isMediaRecordingSupported => true;
  @override
  String get mimeType => 'video/mp4';

  Future<String> _getRecordFilePath() async {
    Directory? extDir;
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    if (UniversalPlatform.isAndroid) {
      extDir = await getExternalStorageDirectory();
      extDir ??= await getApplicationDocumentsDirectory();
    } else {
      extDir = await getApplicationDocumentsDirectory();
    }
    final dirPath = '${extDir.path}/gotok/recordings';
    await Directory(dirPath).create(recursive: true);
    final filePath =
        '$dirPath/$fileName.${UniversalPlatform.isAndroid ? 'webm' : 'mp4'}';
    final file = File(filePath);
    final exists = await file.exists();
    if (exists) {
      await file.delete();
    }
    return filePath;
  }

  @override
  Future<void> startRecorder() async {
    _path = await _getRecordFilePath();
    final file = File(_path);
    final bool exists = await file.exists();
    if (exists) {
      await file.delete();
    }
    try {
      await recorder.start(_path);
    } catch (e) {
      recorder.stop();
      throw _interface.MediaRecorderError(message: e.toString());
    }
  }

  @override
  Future<XFile> stopRecorder() async {
    try {
      await recorder.stop();
      return XFile(_path, mimeType: mimeType);
    } catch (e) {
      return throw _interface.MediaRecorderError(message: e.toString());
    } finally {
      recorder.stop();
    }
  }
}
