import 'dart:math';
import 'package:charts_flutter/src/text_element.dart' as ChartText;
import 'package:charts_flutter/src/text_style.dart' as ChartStyle;
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';


String? _xAxis;
String? _pointColor;

class ToolTipMgr {

  static String? get xAxis => _xAxis;
  static String? get pointColor => _pointColor;


  static setTitle(Map<String, dynamic> data) {
    if (data['xAxis'] != null && data['xAxis'].length > 0) {
      _xAxis = data['xAxis'];
    }

    if (data['pointColor'] != null &&  data['pointColor'].length > 0) {
      _pointColor = data['pointColor'];
    }
  }

}

class CustomCircleSymbolRenderer extends CircleSymbolRenderer {

  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds,
      {List<int>? dashPattern,
        Color? fillColor,
        FillPatternType? fillPattern,
        Color? strokeColor,
        double? strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);

    ChartStyle.TextStyle textStyle = ChartStyle.TextStyle();

    textStyle.color = Color.fromHex(code: ToolTipMgr.pointColor ?? '#505A5F');
    textStyle.fontSize = 14;

    canvas.drawText(
        ChartText.TextElement('${ToolTipMgr.xAxis}', style: textStyle),
        (bounds.left - bounds.width + 5).round(),
        (bounds.height + 20).round());
  }

}