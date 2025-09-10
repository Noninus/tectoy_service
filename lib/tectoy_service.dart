import 'tectoy_service_platform_interface.dart';

class TectoyService {
  Future<String?> getPlatformVersion() {
    return TectoyServicePlatform.instance.getPlatformVersion();
  }

  Future<int> sendPrinterText(String text) async {
    return TectoyServicePlatform.instance.sendPrinterText(text);
  }

  Future<int> sendKotlinPrinterText(String text) async {
    return TectoyServicePlatform.instance.sendKotlinPrinterText(text);
  }

  Future<int> sendPrinterImage(String base64img, {int imgSize = 380}) async {
    return TectoyServicePlatform.instance.sendPrinterImage(base64img, imgSize);
  }

  Future<int> configurarTecToy(String tipoDispositivo) async {
    return TectoyServicePlatform.instance.configurarTecToy(tipoDispositivo);
  }

  Future<int> cortarPapel() async {
    return TectoyServicePlatform.instance.cortarPapel();
  }

  Future<int> paperStatus() async {
    int status = await TectoyServicePlatform.instance.paperStatus();
    if (status == 0) {
      return 1;
    } else {
      return 0;
    }
  }
}
