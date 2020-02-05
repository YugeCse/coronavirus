package com.mrper.coronavirus.core.flutter.plugins

import android.content.Context
import com.mrper.coronavirus.BuildConfig
import com.mrper.coronavirus.core.plugins.getLocationInfo
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val LocationPluginTag = "${BuildConfig.APPLICATION_ID}.plugins.location-plugin"

class LocationFlutterPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {

    private var applicationContext: Context? = null
    private var methodChannel: MethodChannel? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = binding.applicationContext
        methodChannel = MethodChannel(binding.binaryMessenger, LocationPluginTag).apply {
            setMethodCallHandler(this@LocationFlutterPlugin)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        if (methodChannel != null) {
            methodChannel?.setMethodCallHandler(null)
            methodChannel = null
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getLocationInfo" -> applicationContext?.getLocationInfo(
                    call.argument<Int>("scanSpanTime") ?: 0) {
                result.success(mapOf(
                        "province" to it?.province,
                        "address" to it?.addrStr,
                        "longitude" to it?.longitude,
                        "latitude" to it?.latitude
                ))
            }
            else -> result.notImplemented()
        }
    }

}