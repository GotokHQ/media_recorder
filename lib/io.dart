import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' show MultiPartyRecorder;
import 'package:image_picker/image_picker.dart';
import 'package:universal_platform/universal_platform.dart';
import 'interface.dart' as _interface;

class MediaRecorderHelper extends _interface.IMediaRecorderHelper {
  @override
  final MultiPartyRecorder recorder;

  MediaRecorderHelper(this.recorder);

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
      print(e);
      recorder.stop();
      throw _interface.MediaRecorderError(message: e.toString());
    }
  }

  @override
  Future<PickedFile> stopRecorder() async {
    try {
      await recorder.stop();
      return PickedFile(_path);
    } catch (e) {
      return throw _interface.MediaRecorderError(message: e.toString());
    } finally {
      recorder.stop();
    }
  }
}
