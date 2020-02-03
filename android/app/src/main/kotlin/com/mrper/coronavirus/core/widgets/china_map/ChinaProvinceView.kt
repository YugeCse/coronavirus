package com.mrper.coronavirus.core.widgets.china_map

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.util.AttributeSet
import android.view.MotionEvent
import android.view.View
import com.mrper.coronavirus.R
import java.util.concurrent.LinkedBlockingDeque
import java.util.concurrent.ThreadFactory
import java.util.concurrent.ThreadPoolExecutor
import java.util.concurrent.TimeUnit

/** 中国省份视图 **/
class ChinaProvinceView : View, View.OnTouchListener {

    private var data: ChinaMapInfo? = null

    private var mapScale: Float = 1.0f

    private var _selectedProvinceInfo: ChinaProvinceInfo? = null

    /** 当前选择的省份 **/
    var selectedProvinceInfo: ChinaProvinceInfo?
        get() = _selectedProvinceInfo
        set(value) {
            _selectedProvinceInfo = value
        }

    /** 省份选择事件 **/
    var onProvinceSelectedChanged: ((ChinaProvinceInfo) -> Unit)? = null

    constructor(context: Context?) : super(context) {
        init(context)
    }

    constructor(context: Context?, attrs: AttributeSet?) : super(context, attrs) {
        init(context)
    }

    constructor(context: Context?, attrs: AttributeSet?, defStyleAttr: Int) : super(context, attrs, defStyleAttr) {
        init(context)
    }

    @SuppressLint("NewApi")
    constructor(context: Context?, attrs: AttributeSet?, defStyleAttr: Int, defStyleRes: Int) : super(context, attrs, defStyleAttr, defStyleRes) {
        init(context)
    }

    private fun init(context: Context?) {
        setOnTouchListener(this)
        data = context?.getChinaMapInfoByMapRawId(R.raw.ic_map_china)
    }

    override fun onTouch(v: View?, event: MotionEvent?): Boolean {
        if (event?.action == MotionEvent.ACTION_DOWN) {
            val selectedProvinceInfo = data?.provinceInfoList?.firstOrNull { it.isTouched(event.x / mapScale, event.y / mapScale) }
            if (selectedProvinceInfo != null && selectedProvinceInfo != _selectedProvinceInfo) {
                _selectedProvinceInfo?.backgroundColor = Color.TRANSPARENT
                _selectedProvinceInfo = selectedProvinceInfo
                _selectedProvinceInfo?.backgroundColor = Color.RED
                onProvinceSelectedChanged?.invoke(selectedProvinceInfo)
                invalidate()
            }
            return true
        }
        return false
    }

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec)
        val width = MeasureSpec.getSize(widthMeasureSpec)
        var height = MeasureSpec.getSize(heightMeasureSpec)
        if (data != null) {
            mapScale = (width.toFloat() / data!!.viewPortWidth)
            height = (data!!.viewPortHeight * mapScale).toInt()
        }
        setMeasuredDimension(MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY),
                MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY))
    }

    @SuppressLint("DrawAllocation")
    override fun onDraw(canvas: Canvas?) {
        super.onDraw(canvas)
        canvas?.scale(mapScale, mapScale)
        data?.provinceInfoList?.forEach { provinceInfo ->
            provinceInfo.drawPath(canvas, true)
            provinceInfo.drawPath(canvas, false)
        }
        data?.provinceInfoList?.forEach { provinceInfo ->
            provinceInfo.drawName(context, canvas)
        }
    }

}