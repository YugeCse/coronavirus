package com.mrper.coronavirus.core.widgets.china_map

import android.content.Context
import android.graphics.Color
import android.graphics.Path
import android.util.Xml
import androidx.annotation.RawRes
import androidx.core.graphics.PathParser
import org.xml.sax.Attributes
import org.xml.sax.ContentHandler
import org.xml.sax.Locator
import org.xmlpull.v1.XmlPullParser
import org.xmlpull.v1.XmlPullParserFactory
import java.io.BufferedInputStream
import java.io.InputStreamReader
import java.io.StringReader

/**
 * 通过地图资源的RawId获取地图信息
 * @param mapRawId 地图资源ID
 */
fun Context.getChinaMapInfoByMapRawId(@RawRes mapRawId: Int): ChinaMapInfo {
    val xmlPullParser = Xml.newPullParser().apply {
        setInput(StringReader(BufferedInputStream(resources.openRawResource(mapRawId)).bufferedReader().readText()))
    }
    return ChinaMapInfo(provinceInfoList = mutableListOf()).apply {
        var eventType = xmlPullParser.eventType
        while (eventType != XmlPullParser.END_DOCUMENT) {
            try {
                when (eventType) {
                    XmlPullParser.START_TAG -> when (xmlPullParser.name) {
                        "vector" -> {
                            viewPortWidth = xmlPullParser.getAttributeValue(null, "viewportWidth").toFloat()
                            viewPortHeight = xmlPullParser.getAttributeValue(null, "viewportHeight").toFloat()
                        }
                        "path" -> provinceInfoList?.add(ChinaProvinceInfo(ProvinceLayerPathInfo(
                                xmlPullParser.getAttributeValue(null, "name"),
                                xmlPullParser.getAttributeValue(null, "strokeWidth").toFloat(),
                                Color.parseColor(xmlPullParser.getAttributeValue(null, "strokeColor")),
                                Color.parseColor(xmlPullParser.getAttributeValue(null, "fillColor")),
                                PathParser.createPathFromPathData(xmlPullParser.getAttributeValue(null, "pathData"))
                        )))
                    }
                }
                eventType = xmlPullParser.next()
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
}

data class ChinaMapInfo(
        var viewPortWidth: Float = 0f,
        var viewPortHeight: Float = 0f,
        var provinceInfoList: MutableList<ChinaProvinceInfo>? = null
)

data class ProvinceLayerPathInfo(
        var name: String,
        var strokeWidth: Float,
        var strokeColor: Int,
        var backgroundColor: Int,
        var drawPathInfo: Path
)