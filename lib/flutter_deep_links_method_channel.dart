import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_deep_links_platform_interface.dart';

/// An implementation of [FlutterDeepLinksPlatform] that uses method channels.
class MethodChannelFlutterDeepLinks extends FlutterDeepLinksPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_deep_links');

  static const MethodChannel _mChannel = MethodChannel('deep_links/messages');
  static const EventChannel _eChannel = EventChannel('deep_links/events');

  @override
  Future<String?> getInitialLink() =>
      _mChannel.invokeMethod<String?>('getInitialLink');

  @override
  final Stream<String?> linkStream = _eChannel
      .receiveBroadcastStream()
      .map<String?>((dynamic link) => link as String?);
}
