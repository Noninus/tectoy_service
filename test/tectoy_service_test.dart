// import 'package:flutter_test/flutter_test.dart';
// import 'package:tectoy_service/tectoy_service.dart';
// import 'package:tectoy_service/tectoy_service_platform_interface.dart';
// import 'package:tectoy_service/tectoy_service_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockTectoyServicePlatform
//     with MockPlatformInterfaceMixin
//     implements TectoyServicePlatform {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');

//   @override
//   Future<int> sendPrinterImage(String base64img, int imgSize) {
//     // TODO: implement sendPrinterImage
//     throw UnimplementedError();
//   }

//   @override
//   Future<int> sendPrinterText(String text) {
//     // TODO: implement sendPrinterText
//     throw UnimplementedError();
//   }

//   @override
//   Future<int> configurarTecToy(String tipoDispositivo) {
//     // TODO: implement configurarTecToy
//     throw UnimplementedError();
//   }

//   @override
//   Future<int> cortarPapel() {
//     // TODO: implement cortarPapel
//     throw UnimplementedError();
//   }
// }

// void main() {
//   final TectoyServicePlatform initialPlatform = TectoyServicePlatform.instance;

//   test('$MethodChannelTectoyService is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelTectoyService>());
//   });

//   test('getPlatformVersion', () async {
//     TectoyService tectoyServicePlugin = TectoyService();
//     MockTectoyServicePlatform fakePlatform = MockTectoyServicePlatform();
//     TectoyServicePlatform.instance = fakePlatform;

//     expect(await tectoyServicePlugin.getPlatformVersion(), '42');
//   });
// }
