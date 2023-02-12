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

  /// Returns a [Future], which completes to the initially stored link, which
  /// may be null.
  ///
  /// NOTE: base code found in [MethodChannelUniLinks.getInitialLink]
  Future<String?> getInitialLink() => throw UnimplementedError(
      'getInitialLink() has not been implemented on the current platform.');

  /// A broadcast stream for receiving incoming link change events.
  ///
  /// The [Stream] emits opened links as [String]s.
  ///
  /// NOTE: base code found in [MethodChannelUniLinks.linkStream]
  Stream<String?> get linkStream => throw UnimplementedError(
      'getLinksStream has not been implemented on the current platform.');
}
