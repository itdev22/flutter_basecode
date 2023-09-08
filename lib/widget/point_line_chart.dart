import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PointsLineChart extends StatelessWidget {
  final List<charts.Series<DataPerWeek, String>> seriesList;
  final bool animate;
  static Color color1 = const Color(0xFF124DB6);
  static Color color2 = const Color(0xFFADCEB2);
  static Color color3 = Colors.black;

  const PointsLineChart(this.seriesList, {Key? key, required this.animate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return charts.OrdinalComboChart(
      seriesList,
      animate: animate,
      defaultRenderer: charts.LineRendererConfig(includePoints: true),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        showAxisLine: false,
        renderSpec: charts.NoneRenderSpec(),
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredMinTickCount: 6,
          desiredMaxTickCount: 10,
        ),
      ),
      domainAxis: const charts.OrdinalAxisSpec(
        renderSpec: charts.NoneRenderSpec(),
      ),
    );
  }

  static List<charts.Series<DataPerWeek, String>> dataHistogram(
      List<DataPerWeek> data) {
    return [
      charts.Series<DataPerWeek, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.Color.fromHex(code: '#000000'),
        domainFn: (DataPerWeek sales, _) => sales.date,
        measureFn: (DataPerWeek sales, _) => sales.harga,
        data: data,
      ),
    ];
  }
}

/// Sample linear data type.
class DataPerWeek {
  final String date;
  final int harga;

  DataPerWeek(
    this.date,
    this.harga,
  );
}
