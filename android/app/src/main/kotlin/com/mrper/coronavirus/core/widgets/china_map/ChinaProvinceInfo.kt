package com.mrper.coronavirus.core.widgets.china_map

import android.content.Context
import android.graphics.*

/**
 * 中国省份信息
 * @param provinceLayerPathInfo 省份图层信息
 */
class ChinaProvinceInfo(private val provinceLayerPathInfo: ProvinceLayerPathInfo) {

    /** 图形路径 **/
    private var path: Path = provinceLayerPathInfo.drawPathInfo

    /** 描边宽度 **/
    private var _borderWidth: Float = provinceLayerPathInfo.strokeWidth

    /** 描边颜色 **/
    private var _borderColor: Int = provinceLayerPathInfo.strokeColor

    /** 背景色 **/
    private var _bgColor: Int = provinceLayerPathInfo.backgroundColor

    /** 文本颜色 **/
    private var _textColor: Int = Color.BLACK

    /** 文本字体大小 **/
    private var _textSize: Float = 9f

    /** 图形所在的Region **/
    private var region: Region = buildRegion(path)

    /** 设置或获取边框宽度 **/
    var borderWidth: Float
        get() = _borderWidth
        set(value) {
            _borderWidth = value
        }

    /** 设置或获取描边颜色 **/
    var borderColor: Int
        get() = _borderColor
        set(value) {
            _borderColor = value
        }

    /** 设置或获取背景颜色 **/
    var backgroundColor: Int
        get() = _bgColor
        set(value) {
            _bgColor = value
        }

    /** 文本颜色 **/
    var textColor: Int
        get() = _textColor
        set(value) {
            _textColor = value
        }

    /** 文本大小 **/
    var textSize: Float
        get() = _textSize
        set(value) {
            _textSize = value
        }

    private fun buildRegion(path: Path): Region {
        val pathBoundsRect = RectF()
        path.computeBounds(pathBoundsRect, false)
        return Region().apply {
            setPath(path, Region(pathBoundsRect.left.toInt(),
                    pathBoundsRect.top.toInt(),
                    pathBoundsRect.right.toInt(),
                    pathBoundsRect.bottom.toInt()))
        }
    }

    /** 是否被点击 **/
    fun isTouched(x: Float, y: Float) = region.contains(x.toInt(), y.toInt())

    /**
     * 绘制省份路径
     * @param canvas 画布
     * @param isFill 是填充还是描边, 默认为TRUE
     * @param pathColor 颜色，如果不能存在该值时使用对象内置的颜色
     */
    fun drawPath(canvas: Canvas?, isFill: Boolean = true, pathColor: Int? = null) {
        val paint = Paint().apply {
            isAntiAlias = true
            if (isFill) {
                style = Paint.Style.FILL
                color = pathColor ?: _bgColor
            } else {
                style = Paint.Style.STROKE
                color = pathColor ?: _borderColor
                strokeWidth = _borderWidth
            }
        }
        canvas?.drawPath(path, paint)
    }

    /**
     * 绘制省份名称
     * @param context 上下文对象
     * @param canvas 画布
     */
    fun drawName(context: Context?, canvas: Canvas?) {
        val provinceName = provinceLayerPathInfo.name
        val paint = Paint().apply {
            isAntiAlias = true
            style = Paint.Style.FILL
            color = _textColor
            textSize = (context?.resources?.displayMetrics?.scaledDensity ?: 0f) * _textSize + 0.5f
        }
        val drawPoint = getNameDrawOffset(provinceName, paint)
        canvas?.drawText(provinceName, drawPoint.x, drawPoint.y, paint)
    }

    /**
     * 获取省份名称的绘制位置
     * @param provinceName 身份名称
     * @param paint 画笔
     */
    private fun getNameDrawOffset(provinceName: String, paint: Paint): PointF {
        val textBounds = Rect()
        paint.getTextBounds(provinceName, 0, provinceName.length, textBounds)
        val regionWidth = region.bounds.width()
        val regionHeight = region.bounds.height()
        val textWidth = textBounds.width()
        val textHeight = textBounds.height()
        var offsetX: Float = (regionWidth - textWidth) / 2f
        var offsetY: Float = (regionHeight - textHeight) * 2f / 3f
        when (provinceName) {
            "重庆" -> offsetY = regionHeight * 0.7f
            "天津" -> {
                offsetX = regionWidth * 0.7f
                offsetY = regionHeight * 1.0f
            }
            "内蒙古" -> offsetY = regionHeight * 4 / 5f
            "河北" -> {
                offsetX = regionWidth * 0.1f
                offsetY = regionHeight * 0.7f
            }
            "甘肃" -> {
                offsetX = regionWidth * 0.15f
                offsetY = regionHeight * 0.23f
            }
            "陕西" -> offsetY = regionHeight * 0.73f
            "江西" -> offsetX = regionWidth * 0.2f
            "江苏" -> offsetX = regionWidth * 0.55f
            "上海" -> {
                offsetX = regionWidth * 0.8f
                offsetY = regionHeight * 0.8f
            }
            "海南" -> offsetY = regionHeight * 0.7f
            "广东" -> offsetY = regionWidth * 0.3f
            "香港" -> {
                offsetX = regionWidth * 1.0f
                offsetY = regionWidth * 1.0f
            }
            "澳门" -> offsetY = regionWidth * 1.0f + textHeight
        }
        return PointF(region.bounds.left + offsetX, region.bounds.top + offsetY)
    }

}