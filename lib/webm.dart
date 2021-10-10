@JS()
library webm;

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:js/js.dart';

typedef OnDurationComplete = void Function(html.Blob);

@JS('getSeekableBlob')
external String getSeekableBlob(html.Blob blob, OnDurationComplete callback);
