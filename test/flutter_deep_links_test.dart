import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_deep_links/flutter_deep_links.dart';
import 'package:flutter_deep_links/flutter_deep_links_platform_interface.dart';
import 'package:flutter_deep_links/flutter_deep_links_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterDeepLinksPlatform
    with MockPlatformInterfaceMixin
    implements FlutterDeepLinksPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterDeepLinksPlatform initialPlatform = FlutterDeepLinksPlatform.instance;

  test('$MethodChannelFlutterDeepLinks is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterDeepLinks>());
  });

  test('getPlatformVersion', () async {
    FlutterDeepLinks flutterDeepLinksPlugin = FlutterDeepLinks();
    MockFlutterDeepLinksPlatform fakePlatform = MockFlutterDeepLinksPlatform();
    FlutterDeepLinksPlatform.instance = fakePlatform;

    expect(await flutterDeepLinksPlugin.getPlatformVersion(), '42');
  });
}
