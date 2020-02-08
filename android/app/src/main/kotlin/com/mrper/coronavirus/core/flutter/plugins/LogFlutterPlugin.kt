package com.mrper.coronavirus.core.flutter.plugins

import android.util.Log
import com.mrper.coronavirus.BuildConfig
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val LogFlutterPluginTag = "${BuildConfig.APPLICATION_ID}.plugins.log-plugin"

class LogFlutterPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {

    private var methodChannel: MethodChannel? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(binding.binaryMessenger, LogFlutterPluginTag)
                .apply { setMethodCallHandler(this@LogFlutterPlugin) }
    }

    override fun onDetachedFromEngine(p0: FlutterPlugin.FlutterPluginBinding) {
        if (methodChannel != null) {
            methodChannel?.setMethodCallHandler(null)
            methodChannel = null
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "e", "i", "w" -> {
                val message = call.argument<String>("message")
                val tag = call.argument<String>("tag") ?: ""
                when (call.method) {
                    "e" -> Log.e(tag, message)
                    "i" -> Log.i(tag, message)
                    else -> Log.w(tag, message)
                }
                result.success(null)
            }
            "println" -> {
                val obj = call.argument<Any>("object")
                println(obj)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }
}