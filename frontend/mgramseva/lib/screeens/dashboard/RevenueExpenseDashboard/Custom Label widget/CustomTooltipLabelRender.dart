import 'dart:math';
import 'package:charts_flutter/src/text_element.dart' as ChartText;
import 'package:charts_flutter/src/text_style.dart' as ChartStyle;
import 'package:charts_flutter/flutter.dart';


String? _xAxis;
String? _pointColor;
num? _maxVal;

class ToolTipMgr {

  static String? get xAxis => _xAxis;
  static String? get pointColor => _pointColor;
  static num? get maxVal => _maxVal;


  static setTitle(Map<String, dynamic> data) {
    if (data['xAxis'] != null && data['xAxis'].length > 0) {
      _xAxis = data['xAxis'];
    }

    if (data['pointColor'] != null &&  data['pointColor'].length > 0) {
      _pointColor = data['pointColor'];
    }

    if (data['maxVal'] != null) {
      _maxVal = data['maxVal'];
    }
  }

  static setMaxValue(num maxVale){
    _maxVal = maxVale;
  }

}

class CustomTooltipLabelRenderer extends CircleSymbolRenderer {

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

    canvas.drawRRect(
      Rectangle((bounds.left - bounds.width - 5).round(), (bounds.height - 30).round(),
          bounds.width + 45, (bounds.height + 10).round()),
      fill: Color.fromHex(code: '#EEEEEE'),
      roundTopLeft: true, roundTopRight: true, roundBottomLeft: true, roundBottomRight: true,
      radius: 4);

    ChartStyle.TextStyle textStyle = ChartStyle.TextStyle();

    textStyle.color = Color.fromHex(code: ToolTipMgr.pointColor ?? '#505A5F');

    textStyle.fontSize = 12;

    canvas.drawText(
        ChartText.TextElement('₹ ${ToolTipMgr.xAxis}', style: textStyle),
        (bounds.left - bounds.width ).round(),
        -10);
  }

}