import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data' show Uint8List;

import 'tectoy_service_platform_interface.dart';

/// An implementation of [TectoyServicePlatform] that uses method channels.
class MethodChannelTectoyService extends TectoyServicePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tectoy_service');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<int> sendPrinterText(String text) async {
    return await methodChannel.invokeMethod("Printy", {"arguments": text});
  }

  img.Image _b64ToImage(String b64, int imgSize) {
    img.Image? image = img.decodeImage(base64.decode(b64));
    return img.copyResize(image, width: imgSize);
  }

  String _imageToBase64(img.Image image) {
    return base64Encode(img.encodeJpg(image));
  }

  @override
  Future<int> sendPrinterImage(String base64img, int imgSize) async {
    img.Image imagemResized = _b64ToImage(base64img, imgSize);
    String imageBase64 = _imageToBase64(imagemResized);

    Uint8List decodedBytes = base64.decode(imageBase64);
    Directory tempPath = await getTemporaryDirectory();
    File file = File('${tempPath.path}/img.jpg');
    await file.writeAsBytes(decodedBytes.buffer
        .asUint8List(decodedBytes.offsetInBytes, decodedBytes.lengthInBytes));

    return await methodChannel
        .invokeMethod("printimage", {"arguments": file.path});
  }

  @override
  Future<int> configurarTecToy(String tipoDispositivo) async {
    return await methodChannel
        .invokeMethod("configurarTecToy", {"arguments": tipoDispositivo});
  }

  @override
  Future<int> cortarPapel() async {
    return await methodChannel.invokeMethod("cortarPapel");
  }
}
