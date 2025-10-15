package br.com.sagresinformatica.tectoy_service

import androidx.annotation.NonNull
import android.app.Activity
import android.content.Context

import br.com.itfast.tectoy.Dispositivo
import br.com.itfast.tectoy.TecToy
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** TectoyServicePlugin */
class TectoyServicePlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  // ESC a n - Alinhamento: n=0(esquerda), n=1(centro), n=2(direita)
  val centro = "" + 0x1B.toChar() + 0x61.toChar() + 0x01.toChar()
  val deslCentro = "" + 0x1B.toChar() + 0x61.toChar() + 0x30.toChar()
  val direita = "" + 0x1B.toChar() + 0x61.toChar() + 0x32.toChar()
  val deslDireita = "" + 0x1B.toChar() + 0x61.toChar() + 0x30.toChar()
  val extra = "" + 0x1B.toChar() + 0x21.toChar() + 0x16.toChar()
  val deslExtra = "" + 0x1B.toChar() + 0x21.toChar() + 0x00.toChar()
  val negrito = "" + 0x1B.toChar() + 0x45.toChar() + 0x31.toChar()
  val deslNegrito = "" + 0x1B.toChar() + 0x45.toChar() + 0x30.toChar()

  val invetImp = "" + 0x1D.toChar() + 0x42.toChar() + 0x31.toChar()
  val desligInvert = "" + 0x1D.toChar() + 0x42.toChar() + 0x30.toChar()


  private var tecToy: TecToy? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "tectoy_service")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext;
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
        "getPlatformVersion" -> {
          result.success("Android ${android.os.Build.VERSION.RELEASE}")
        }
        "configurarTecToy" -> {
          val argument = call.arguments as Map<String, String>
          val name = argument["arguments"]
          if(name=="K2_MINI"){
            tecToy = TecToy(Dispositivo.K2_MINI, context)
          }else if(name=="K2"){
            tecToy = TecToy(Dispositivo.K2, context)
          } else {
            tecToy = TecToy(Dispositivo.K2, context)
          }

          result.success(1)
        }
        "Printy" -> {
          val argument = call.arguments as Map<String, String>
          val name = argument["arguments"]
          tecToy!!.imprimir(name.toString())
          result.success(1)
        }
        "PrintyTestJava" -> {
          val argument = call.arguments as Map<String, String>
          val name = argument["arguments"]
       
  
          var cmdHead = invetImp+ centro + extra + negrito + "          * * * T E C T O Y * * *          " + deslNegrito + deslExtra +"\n"+ desligInvert ;
          cmdHead += centro + extra + "Teste formatado" + " / " + "IT Fast" + deslExtra + "\n\n";
          cmdHead += deslCentro+ extra + "Fonte extra" + " - " + "TecToy Automação" + deslExtra + "\n\n";
          cmdHead += centro + extra + negrito + " Resumo do Pedido " + deslNegrito + deslExtra + "\n\n";
          cmdHead += deslCentro+"\n\n\n\n";
          tecToy!!.imprimir(cmdHead);
          tecToy!!.acionarGuilhotina();
          
          tecToy!!.imprimir(name.toString())
          result.success(1)
        }
        "printimage" -> {
          val argument = call.arguments as Map<String, String>
          val name = argument["arguments"]
          tecToy!!.imprimirImagem(name.toString())
          result.success(1)
        }
        "cortarPapel" -> {
          tecToy!!.acionarGuilhotina();
          result.success(1)
        }
        "statusImpressora" -> {
          result.success(tecToy!!.statusImpressora().obtemStatus())
        }
        else -> {
          result.notImplemented()
        }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

}
