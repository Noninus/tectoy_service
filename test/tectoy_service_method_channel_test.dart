import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tectoy_service/tectoy_service_method_channel.dart';

void main() {
  MethodChannelTectoyService platform = MethodChannelTectoyService();
  const MethodChannel channel = MethodChannel('tectoy_service');

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
