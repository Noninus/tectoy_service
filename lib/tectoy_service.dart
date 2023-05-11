import 'tectoy_service_platform_interface.dart';

class TectoyService {
  Future<String?> getPlatformVersion() {
    return TectoyServicePlatform.instance.getPlatformVersion();
  }

  Future<int> sendPrinterText(String text) async {
    return TectoyServicePlatform.instance.sendPrinterText(text);
  }

  Future<int> sendPrinterImage(String base64img) async {
    return TectoyServicePlatform.instance.sendPrinterImage(base64img);
  }

  Future<int> configurarTecToy(String tipoDispositivo) async {
    return TectoyServicePlatform.instance.configurarTecToy(tipoDispositivo);
  }
}
