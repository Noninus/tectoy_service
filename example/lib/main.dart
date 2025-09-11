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

  Future<void> _imprimirSenhaInvertida() async {
    try {
      var senhaText = 'SENHA 123';
      int quantidadeEmBranco = 24 - senhaText.length;
      var quantidadeFinal = (quantidadeEmBranco % 2 == 0
          ? quantidadeEmBranco
          : quantidadeEmBranco - 1);
      String branco = "".padLeft(quantidadeFinal + senhaText.length, " ");
      String brancoMeio = "".padLeft((quantidadeFinal / 2).floor(), " ");

      // Senha em destaque com inversão
      String senhaInvertida =
          "$invetImp$negrito$extra$branco\n$brancoMeio$senhaText$brancoMeio\n$branco$desligInvert$deslNegrito$deslExtra\n\n\n";

      await _tectoyServicePlugin.sendPrinterText(senhaInvertida);
      await Future.delayed(const Duration(milliseconds: 25));

      // Cortar papel
      await _tectoyServicePlugin.cortarPapel();
      await Future.delayed(const Duration(milliseconds: 150));

      messengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('Senha impressa com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Erro ao imprimir senha: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _imprimirRecibo() async {
    try {
      var senhaText = 'SENHA 1842';
      int quantidadeEmBranco = 48 - senhaText.length;
      var quantidadeFinal = (quantidadeEmBranco % 2 == 0
          ? quantidadeEmBranco
          : quantidadeEmBranco - 1);
      String branco = "".padLeft(quantidadeFinal + senhaText.length, " ");
      String brancoMeio = "".padLeft((quantidadeFinal / 2).floor(), " ");

      await Future.delayed(const Duration(milliseconds: 25));

      // Senha em destaque com inversão
      String senhaInvertida =
          "$invetImp$negrito$extra$branco\n$brancoMeio$senhaText$brancoMeio\n$branco$desligInvert$deslNegrito$deslExtra\n\n";

      await _tectoyServicePlugin.sendPrinterText(senhaInvertida);
      await Future.delayed(const Duration(milliseconds: 25));

      // Nome da empresa centralizado
      String empresaNome = "${centro}EMPRESA TESTE$deslCentro\n\n";
      await _tectoyServicePlugin.sendPrinterText(empresaNome);
      await Future.delayed(const Duration(milliseconds: 25));

      // Linha com identificação e terminal
      String identificacao = "Identificacao: #123";
      String terminal = "TERMINAL: 001";
      int espacos = 42 - identificacao.length - terminal.length;
      String linha1 = "$identificacao${"".padLeft(espacos, " ")}$terminal\n";
      await _tectoyServicePlugin.sendPrinterText(linha1);
      await Future.delayed(const Duration(milliseconds: 25));

      await _tectoyServicePlugin.sendPrinterText("\n");

      // Informações do recibo
      String semValor = "SEM VALOR FISCAL";
      String data1 = "19/08/1998";
      espacos = 42 - semValor.length - data1.length;
      String linha2 = "$semValor${"".padLeft(espacos, " ")}$data1\n";
      await _tectoyServicePlugin.sendPrinterText(linha2);

      String naoPagamento = "NAO COMPROVA PAGAMENTO";
      String data2 = "19/08/1998";
      espacos = 42 - naoPagamento.length - data2.length;
      String linha3 = "$naoPagamento${"".padLeft(espacos, " ")}$data2\n";
      await _tectoyServicePlugin.sendPrinterText(linha3);

      // Seção de produtos
      await _tectoyServicePlugin.sendPrinterText("\n");
      String cabecalhoProdutos = "Qtd  Produtos${"".padLeft(24, " ")}Total\n";
      await _tectoyServicePlugin.sendPrinterText(cabecalhoProdutos);

      String divisor = "-----------------------------------------\n";
      await _tectoyServicePlugin.sendPrinterText(divisor);

      // Produtos exemplo
      String produto1 = "2    Hamburguer${"".padLeft(20, " ")}24,00\n";
      await _tectoyServicePlugin.sendPrinterText(produto1);

      String produto2 = "1    Refrigerante${"".padLeft(17, " ")}8,32\n";
      await _tectoyServicePlugin.sendPrinterText(produto2);

      await _tectoyServicePlugin.sendPrinterText(divisor);

      // Total
      String totalLinha = "${direita}Valor total: R\$ 32,32$deslDireita\n\n";
      await _tectoyServicePlugin.sendPrinterText(totalLinha);

      // Rodapé
      String rodape =
          "${centro}Prato Digital v123\n(43) 3338-8099$deslCentro\n\n\n";
      await _tectoyServicePlugin.sendPrinterText(rodape);

      // Cortar papel
      await _tectoyServicePlugin.cortarPapel();
      await Future.delayed(const Duration(milliseconds: 150));

      print("Sucesso! Recibo impresso.");
      messengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('Recibo impresso com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print("Erro ao imprimir: $e");
      messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Erro ao imprimir: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
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
          duration: const Duration(seconds: 2),
        ),
      );
    } on Exception catch (e) {
      _status = 0;

      messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('erro: $e'),
          duration: const Duration(seconds: 2),
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text("direita"),
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
                    const Text("centro"),
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
                    const Text("extra"),
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
                    const Text("negrito"),
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
                    const Text("invert"),
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
                child: const Text("_configurarTecToy")),
            ElevatedButton(
                onPressed: () => _imprimirRecibo(),
                child: const Text("Imprimir Recibo Teste",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            ElevatedButton(
                onPressed: () => _imprimirSenhaInvertida(),
                child: const Text("Imprimir Senha Invertida",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ))
          ],
        ),
      ),
    );
  }
}
