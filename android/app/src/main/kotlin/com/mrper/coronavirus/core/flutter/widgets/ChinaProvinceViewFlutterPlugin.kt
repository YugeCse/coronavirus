package com.mrper.coronavirus.core.flutter.widgets

import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.view.View
import com.mrper.coronavirus.core.widgets.china_map.ChinaProvinceView
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.*
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

private const val ChinaProvinceViewFlutterViewTag = "com.mrper.coronavirus.widgets.china-province-view"

/** 中国省份的视图插件 **/
class ChinaProvinceViewFlutterPlugin : FlutterPlugin {

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        binding.platformViewRegistry.registerViewFactory(ChinaProvinceViewFlutterViewTag,
                ChinaProvinceViewFlutterViewFactory(binding.binaryMessenger))
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {

    }

}

class ChinaProvinceViewFlutterViewFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    @Suppress("UNCHECKED_CAST")
    override fun create(ctx: Context?, viewId: Int, params: Any?) = ChinaProvinceViewFlutterView(messenger, ctx, viewId, params as? Map<String, Any?>?)

}

class ChinaProvinceViewFlutterView(messenger: BinaryMessenger, private val ctx: Context?, viewId: Int, params: Map<String, Any?>?)
    : PlatformView, MethodChannel.MethodCallHandler, EventChannel.StreamHandler {

    private var chinaProvinceView: ChinaProvinceView? = null
    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null

    init {
        methodChannel = MethodChannel(messenger, "$ChinaProvinceViewFlutterViewTag-$viewId").apply {
            setMethodCallHandler(this@ChinaProvinceViewFlutterView)
        }
        eventChannel = EventChannel(messenger, "$ChinaProvinceViewFlutterViewTag-$viewId-event").apply {
            setStreamHandler(this@ChinaProvinceViewFlutterView)
        }
    }

    override fun getView(): View {
        if (chinaProvinceView == null) chinaProvinceView = ChinaProvinceView(ctx)
        return chinaProvinceView!!
    }

    override fun onMethodCall(method: MethodCall, result: MethodChannel.Result) {
        when (method.method) {
            "setSelectedBackgroundColor" -> { //设置选中后的区域背景色
                chinaProvinceView?.selectedBackgroundColor = method.argument<Long>("value")?.toInt()
                        ?: Color.RED
                result.success(null)
            }
        }
    }

    override fun onListen(p0: Any?, eventSink: EventChannel.EventSink?) {
        chinaProvinceView?.onProvinceSelectedChanged = { provinceInfo ->
            eventSink?.success(provinceInfo?.provinceLayerPathInfo?.name)
        }
    }

    override fun onCancel(p0: Any?) {
    }

    override fun dispose() {
        if (methodChannel != null) {
            methodChannel?.setMethodCallHandler(null)
            methodChannel = null
        }
        if (eventChannel != null) {
            eventChannel?.setStreamHandler(null)
            eventChannel = null
        }
        if (chinaProvinceView != null) {
            chinaProvinceView?.onProvinceSelectedChanged = null
            chinaProvinceView = null
        }
    }

}