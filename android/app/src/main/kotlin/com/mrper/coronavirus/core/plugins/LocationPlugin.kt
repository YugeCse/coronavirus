package com.mrper.coronavirus.core.plugins

import android.content.Context
import com.baidu.location.BDAbstractLocationListener
import com.baidu.location.BDLocation
import com.baidu.location.LocationClient
import com.baidu.location.LocationClientOption

/**
 * 获取定位信息
 * @param scanSpanTime 设置发起定位请求的间隔，int类型，单位ms, 如果设置为0，则代表单次定位，即仅定位一次，默认为0,如果设置非0，需设置1000ms以上才有效
 * @param onPubResult 结果信息返回
 */
fun Context.getLocationInfo(scanSpanTime: Int = 0, onPubResult: (location: BDLocation?) -> Unit) = LocationClient(applicationContext).apply {
    registerLocationListener(object : BDAbstractLocationListener() {
        override fun onReceiveLocation(location: BDLocation?) = onPubResult(location)
    })
    locOption = LocationClientOption().apply {
        setIsNeedAddress(true)
        coorType = "bd09ll"
        scanSpan = scanSpanTime
        openGps = true
    }
}.start()