package com.mrper.coronavirus.core.widgets.china_map

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.*
import android.util.AttributeSet
import android.view.MotionEvent
import android.view.View
import com.mrper.coronavirus.R
import com.mrper.coronavirus.utils.view.DensityUtil
import java.util.concurrent.LinkedBlockingDeque
import java.util.concurrent.ThreadFactory
import java.util.concurrent.ThreadPoolExecutor
import java.util.concurrent.TimeUnit

/** 中国省份视图 **/
class ChinaProvinceView : View, View.OnTouchListener {

    /** 地图数据 **/
    private var _data: ChinaMapInfo? = null

    /** 地图的缩放倍率 **/
    private var _mapScale: Float = 1.0f

    /** 选中区域的背景色 **/
    private var _selectedBgColor: Int = Color.RED

    /** 设置或获取选中区域的背景色 **/
    var selectedBackgroundColor: Int
        get() = _selectedBgColor
        set(value) {
            _selectedBgColor = value
            _data?.provinceInfoList?.forEach { it.selectedBackgroundColor = _selectedBgColor }
            invalidate()
        }

    /** 设置或获取当前选择的省份 **/
    var selectedProvinceInfo: ChinaProvinceInfo?
        get() = _data?.provinceInfoList?.firstOrNull { it.isSelected }
        set(value) {
            _data?.provinceInfoList?.forEach {
                it.isSelected = it.provinceLayerPathInfo.name == value?.provinceLayerPathInfo?.name
            }
            value?.let {
                onProvinceSelectedChanged?.invoke(value,
                        PointF(DensityUtil.px2dip(context, value.rect.centerX() * _mapScale),
                                DensityUtil.px2dip(context, value.rect.centerY() * _mapScale)))
            }
            invalidate()
        }

    /** 省份选择事件 **/
    var onProvinceSelectedChanged: ((ChinaProvinceInfo?, PointF?) -> Unit)? = null

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
        _data = context?.getChinaMapInfoByMapRawId(R.raw.ic_map_china)
    }

    /** 根据省份名称设置被选中的城市的名称 **/
    fun setSelectedProvinceByName(provinceName: String) {
        _data?.provinceInfoList?.forEach { it.isSelected = provinceName.contains(it.provinceLayerPathInfo.name) }
        selectedProvinceInfo?.let { value ->
            onProvinceSelectedChanged?.invoke(value,
                    PointF(DensityUtil.px2dip(context, value.rect.centerX() * _mapScale),
                            DensityUtil.px2dip(context, value.rect.centerY() * _mapScale)))
        }
        invalidate()
    }

    /** 设置省份的背景颜色 **/
    fun setProvinceBackgroundColor(provinceName: String, color: Int) {
        _data?.provinceInfoList?.firstOrNull { it.provinceLayerPathInfo.name.contains(provinceName) }?.backgroundColor = color
        invalidate()
    }

    /**
     * 设置多个省份的背景颜色
     * @param params 参数对应关系 省份名：backgroundColor(int)
     */
    fun setProvincesBackgroundColors(params: Map<String, Any>) {
        _data?.provinceInfoList?.forEach {
            if (params.containsKey(it.provinceLayerPathInfo.name))
                it.backgroundColor = params[it.provinceLayerPathInfo.name].toString().toLong().toInt()
        }
        invalidate()
    }

    override fun onTouch(v: View?, event: MotionEvent?): Boolean {
        if (event?.action == MotionEvent.ACTION_DOWN) {
            val tx = event.x / _mapScale
            val ty = event.y / _mapScale
            val selectedProvinceInfo = _data?.provinceInfoList?.firstOrNull { it.isTouched(tx, ty) }
            _data?.provinceInfoList?.forEach { it.isSelected = it.provinceLayerPathInfo.name == selectedProvinceInfo?.provinceLayerPathInfo?.name }
            onProvinceSelectedChanged?.invoke(selectedProvinceInfo,
                    if (selectedProvinceInfo == null) null else PointF(DensityUtil.px2dip(context, selectedProvinceInfo.rect.centerX() * _mapScale),
                            DensityUtil.px2dip(context, selectedProvinceInfo.rect.centerY() * _mapScale)))
            invalidate()
            return true
        }
        return false
    }

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec)
        val width = MeasureSpec.getSize(widthMeasureSpec)
        var height = MeasureSpec.getSize(heightMeasureSpec)
        _data?.let {
            _mapScale = (width.toFloat() / _data!!.viewPortWidth)
            height = (_data!!.viewPortHeight * _mapScale).toInt()
        }
        setMeasuredDimension(MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY),
                MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY))
    }

    @SuppressLint("DrawAllocation")
    override fun onDraw(canvas: Canvas?) {
        super.onDraw(canvas)
        canvas?.scale(_mapScale, _mapScale)
        _data?.provinceInfoList?.forEach { provinceInfo ->
            provinceInfo.drawPath(canvas, true)
            provinceInfo.drawPath(canvas, false)
        }
        _data?.provinceInfoList?.forEach { provinceInfo ->
            provinceInfo.drawName(context, canvas)
        }
    }

}