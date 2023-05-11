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
        else -> {
          result.notImplemented()
        }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

}
