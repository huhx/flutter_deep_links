import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_deep_links_method_channel.dart';

abstract class FlutterDeepLinksPlatform extends PlatformInterface {
  /// Constructs a FlutterDeepLinksPlatform.
  FlutterDeepLinksPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterDeepLinksPlatform _instance = MethodChannelFlutterDeepLinks();

  /// The default instance of [FlutterDeepLinksPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterDeepLinks].
  static FlutterDeepLinksPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterDeepLinksPlatform] when
  /// they register themselves.
  static set instance(FlutterDeepLinksPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
