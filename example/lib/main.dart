import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:tectoy_service/tectoy_service.dart';
import 'package:tectoy_service_example/img_nota.dart';
import 'package:tectoy_service_example/img_string.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _tectoyServicePlugin = TectoyService();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _tectoyServicePlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  _printText() {
    try {
      _tectoyServicePlugin.sendPrinterText("teste tectoy\n\n\n");
    } on PlatformException {
      // platformVersion = 'Failed to get platform version.';
    }
  }

  _pularLinha() {
    try {
      _tectoyServicePlugin.sendPrinterText("\n");
    } on PlatformException {
      // platformVersion = 'Failed to get platform version.';
    }
  }

  _printImageString() {
    try {
      _tectoyServicePlugin.sendPrinterImage(imgString);
    } on PlatformException {
      // platformVersion = 'Failed to get platform version.';
    }
  }

  _printImageNota() {
    try {
      _tectoyServicePlugin.sendPrinterImage(imgNota);
    } on PlatformException {
      // platformVersion = 'Failed to get platform version.';
    }
  }

  _configurarTecToy(String tipoDispositivo) {
    try {
      _tectoyServicePlugin.configurarTecToy(tipoDispositivo);
    } on PlatformException {
      // platformVersion = 'Failed to get platform version.';
    }
  }

  _cortarPapel() {
    try {
      _tectoyServicePlugin.cortarPapel();
    } on PlatformException {
      // platformVersion = 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            ElevatedButton(
                onPressed: () => _pularLinha(),
                child: const Text("_pularLinha")),
            ElevatedButton(
                onPressed: () => _printText(), child: const Text("_printText")),
            ElevatedButton(
                onPressed: () => _printImageString(),
                child: const Text("_printImageString")),
            ElevatedButton(
                onPressed: () => _printImageNota(),
                child: const Text("_printImageNota")),
            ElevatedButton(
                onPressed: () => _cortarPapel(),
                child: const Text("_cortarPapel")),
            ElevatedButton(
                onPressed: () => _configurarTecToy("K2_MINI"),
                child: const Text("_configurarTecToy"))
          ],
        ),
      ),
    );
  }
}
