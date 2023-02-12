// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:async';

import 'flutter_deep_links_platform_interface.dart';

class FlutterDeepLinks {
  /// Returns a [Future], which completes to the initially stored link, which
  /// may be null.
  Future<String?> getInitialLink() =>
      FlutterDeepLinksPlatform.instance.getInitialLink();

  /// A convenience method that returns the initially stored link
  /// as a new [Uri] object.
  ///
  /// If the link is not valid as a URI or URI reference,
  /// a [FormatException] is thrown.
  Future<Uri?> getInitialUri() async {
    final String? link = await getInitialLink();
    if (link == null) return null;
    return Uri.parse(link);
  }

  /// A broadcast stream for receiving incoming link change events.
  ///
  /// The [Stream] emits opened links as [String]s.
  Stream<String?> get linkStream =>
      FlutterDeepLinksPlatform.instance.linkStream;

  /// A convenience transformation of the [linkStream] to a `Stream<Uri>`.
  ///
  /// If the link is not valid as a URI or URI reference,
  /// a [FormatException] is thrown.
  ///
  /// If the app was stared by a link intent or user activity the stream will
  /// not emit that initial uri - query either the `getInitialUri` instead.
  late final uriLinkStream = linkStream.transform<Uri?>(
    StreamTransformer<String?, Uri?>.fromHandlers(
      handleData: (String? link, EventSink<Uri?> sink) {
        if (link == null) {
          sink.add(null);
        } else {
          sink.add(Uri.parse(link));
        }
      },
    ),
  );
}
