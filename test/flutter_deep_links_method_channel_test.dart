import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_deep_links/flutter_deep_links_method_channel.dart';

void main() {
  MethodChannelFlutterDeepLinks platform = MethodChannelFlutterDeepLinks();
  const MethodChannel channel = MethodChannel('flutter_deep_links');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
