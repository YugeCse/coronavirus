package com.mrper.coronavirus

import androidx.annotation.NonNull;
import com.mrper.coronavirus.core.flutter.plugins.LocationFlutterPlugin
import com.mrper.coronavirus.core.flutter.plugins.LogFlutterPlugin
import com.mrper.coronavirus.core.flutter.widgets.ChinaProvinceViewFlutterPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        flutterEngine.plugins.add(
                mutableSetOf(
                        LogFlutterPlugin(),
                        ChinaProvinceViewFlutterPlugin(),
                        LocationFlutterPlugin()
                )
        )
    }

}
