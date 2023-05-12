import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'tectoy_service_method_channel.dart';

abstract class TectoyServicePlatform extends PlatformInterface {
  /// Constructs a TectoyServicePlatform.
  TectoyServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static TectoyServicePlatform _instance = MethodChannelTectoyService();

  /// The default instance of [TectoyServicePlatform] to use.
  ///
  /// Defaults to [MethodChannelTectoyService].
  static TectoyServicePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TectoyServicePlatform] when
  /// they register themselves.
  static set instance(TectoyServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<int> sendPrinterText(String text) async {
    throw UnimplementedError('sendPrinterText() has not been implemented.');
  }

  Future<int> sendPrinterImage(String base64img, int imgSize) async {
    throw UnimplementedError('sendPrinterImage() has not been implemented.');
  }

  Future<int> configurarTecToy(String tipoDispositivo) async {
    throw UnimplementedError('configurarTecToy() has not been implemented.');
  }

  Future<int> cortarPapel() async {
    throw UnimplementedError('cortarPapel() has not been implemented.');
  }
}
