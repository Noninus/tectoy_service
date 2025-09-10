import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:tectoy_service/tectoy_service.dart';
import 'package:tectoy_service_example/img_nota.dart';
import 'package:tectoy_service_example/img_string.dart';

String centro = String.fromCharCode(0x1B) +
    String.fromCharCode(0x61) +
    String.fromCharCode(0x31);
String deslCentro = String.fromCharCode(0x1B) +
    String.fromCharCode(0x61) +
    String.fromCharCode(0x30);
String direita = String.fromCharCode(0x1B) +
    String.fromCharCode(0x61) +
    String.fromCharCode(0x32);
String deslDireita = String.fromCharCode(0x1B) +
    String.fromCharCode(0x61) +
    String.fromCharCode(0x30);
String extra = String.fromCharCode(0x1B) +
    String.fromCharCode(0x21) +
    String.fromCharCode(0x16);
String deslExtra = String.fromCharCode(0x1B) +
    String.fromCharCode(0x21) +
    String.fromCharCode(0x00);
String negrito = String.fromCharCode(0x1B) +
    String.fromCharCode(0x45) +
    String.fromCharCode(0x31);
String deslNegrito = String.fromCharCode(0x1B) +
    String.fromCharCode(0x45) +
    String.fromCharCode(0x30);

String invetImp = String.fromCharCode(0x1D) +
    String.fromCharCode(0x42) +
    String.fromCharCode(0x31);
String desligInvert = String.fromCharCode(0x1D) +
    String.fromCharCode(0x42) +
    String.fromCharCode(0x30);

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
  TextEditingController controller = TextEditingController();
  bool _direitaToggle = false;
  bool _centroToggle = false;
  bool _extraToggle = false;
  bool _negritoToggle = false;
  bool _invertToggle = false;
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

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

  String imprimir = "";
  fazerTest() {
    try {
      setState(() {
        imprimir = (_centroToggle ? centro : "") +
            (_direitaToggle ? direita : "") +
            (_extraToggle ? extra : "") +
            (_negritoToggle ? negrito : "") +
            (_invertToggle ? invetImp : "") +
            controller.text +
            (_invertToggle ? desligInvert : "") +
            (_negritoToggle ? deslNegrito : "") +
            (_extraToggle ? deslExtra : "") +
            (_direitaToggle ? deslDireita : "") +
            (_centroToggle ? deslCentro : "");
      });

      print(imprimir);
      _tectoyServicePlugin.sendPrinterText(imprimir);
    } on PlatformException {
      // platformVersion = 'Failed to get platform version.';
    }
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

  _printKotlin() {
    try {
      _tectoyServicePlugin.sendKotlinPrinterText(imgNota);
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

  var _status = 0;

  _paperStatus(context) async {
    try {
      _status = await _tectoyServicePlugin.paperStatus();
      messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('sts: $_status'),
          duration: Duration(seconds: 2),
        ),
      );
    } on Exception catch (e) {
      _status = 0;

      messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('erro: $e'),
          duration: Duration(seconds: 2),
        ),
      );
      // platformVersion = 'Failed to get platform version.';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: messengerKey,
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            Center(
              child: Text('stats on: $_status\n'),
            ),
            ElevatedButton(
                onPressed: () => _pularLinha(),
                child: const Text("_pularLinha")),
            Text(
              imprimir,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text("direita"),
                    Checkbox(
                      value: _direitaToggle,
                      onChanged: (v) {
                        setState(() {
                          _direitaToggle = v!;
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("centro"),
                    Checkbox(
                      value: _centroToggle,
                      onChanged: (v) {
                        setState(() {
                          _centroToggle = v!;
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("extra"),
                    Checkbox(
                      value: _extraToggle,
                      onChanged: (v) {
                        setState(() {
                          _extraToggle = v!;
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("negrito"),
                    Checkbox(
                      value: _negritoToggle,
                      onChanged: (v) {
                        setState(() {
                          _negritoToggle = v!;
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("invert"),
                    Checkbox(
                      value: _invertToggle,
                      onChanged: (v) {
                        setState(() {
                          _invertToggle = v!;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
            TextField(controller: controller),
            ElevatedButton(
                onPressed: () => fazerTest(),
                child: const Text("Fazer teste impressao")),
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
                onPressed: () => _paperStatus(context),
                child: const Text("_paperStatus")),
            ElevatedButton(
                onPressed: () => _printKotlin(),
                child: const Text("_printKotlin")),
            ElevatedButton(
                onPressed: () => _configurarTecToy("K2_MINI"),
                child: const Text("_configurarTecToy"))
          ],
        ),
      ),
    );
  }
}
