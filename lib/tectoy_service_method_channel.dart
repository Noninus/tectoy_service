import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

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

  @override
  Future<int> sendPrinterImage(String base64img) async {
    Uint8List decodedBytes = base64.decode(base64img);
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
}
