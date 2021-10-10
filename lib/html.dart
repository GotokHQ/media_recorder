import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:js/js.dart';
import 'package:browser_adapter/browser_adapter.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:image_picker/image_picker.dart';
import 'interface.dart' as _interface;
import 'webm.dart';

class MediaRecorderHelper extends _interface.IMediaRecorderHelper {
  @override
  final MultiPartyRecorder recorder;
  String? _mimeType;
  Completer<html.Blob>? _completer;
  MediaRecorderHelper(this.recorder);
  @override
  String? get mimeType => _mimeType;

  @override
  bool get isMediaRecordingSupported {
    try {
      return (html.MediaRecorder.isTypeSupported('video/mp4') ||
          html.MediaRecorder.isTypeSupported('video/webm'));
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> startRecorder() async {
    try {
      if (isSafariBrowser()) {
        _mimeType = 'video/mp4';
      } else {
        if (html.MediaRecorder.isTypeSupported('video/mp4')) {
          _mimeType = 'video/mp4';
        } else if (html.MediaRecorder.isTypeSupported(
            'video/webm; codecs=h264')) {
          _mimeType = 'video/webm; codecs=h264';
        } else {
          _mimeType = 'video/webm';
        }
      }
      var chunks = <html.Blob>[];
      _completer = Completer<html.Blob>();
      recorder.startWeb(
          mimeType: _mimeType,
          onDataChunk: (b, bool isLastOne) {
            final html.Blob blob = b as html.Blob;
            if (blob.size > 0) {
              chunks.add(blob);
            }
            if (isLastOne) {
              final blob = html.Blob(chunks, _mimeType);
              _completer?.complete(blob);
            }
          });
    } catch (e, stack) {
      print('got error while starting track: $e');
      print('stack: $stack');
      recorder.stop();
      throw _interface.MediaRecorderError(message: e.toString());
    }
  }

  @override
  Future<PickedFile> stopRecorder() async {
    try {
      await recorder.stop();
      final html.Blob blob =
          await _completer?.future ?? Future.value() as html.Blob;
      if (_mimeType!.startsWith("video/webm")) {
        Completer<PickedFile> completer = Completer();
        getSeekableBlob(blob, allowInterop((html.Blob blob) {
          completer.complete(
            PickedFile(
              html.Url.createObjectUrlFromBlob(blob),
            ),
          );
        }));
        return completer.future;
      } else {
        return PickedFile(
          html.Url.createObjectUrlFromBlob(blob),
        );
      }
    } catch (e, stack) {
      print('got error while stoppinng track: $e');
      print('stack: $stack');
      return throw _interface.MediaRecorderError(message: e.toString());
    } finally {
      recorder.stop();
    }
  }
}
