import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_deep_links_platform_interface.dart';

/// An implementation of [FlutterDeepLinksPlatform] that uses method channels.
class MethodChannelFlutterDeepLinks extends FlutterDeepLinksPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_deep_links');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
