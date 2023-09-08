import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class HistogramHome extends StatelessWidget {
  final List<charts.Series<HistogramData, String>> seriesList;
  final bool animate;
  final String labelSecondary;

  const HistogramHome(this.seriesList, {Key? key, required this.animate, required this.labelSecondary})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return charts.OrdinalComboChart(
      seriesList,
      animate: animate,
      defaultRenderer: charts.LineRendererConfig(),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredMinTickCount: 6,
          desiredMaxTickCount: 10,
        ),
      ),
      secondaryMeasureAxis: const charts.NumericAxisSpec(
          tickProviderSpec: charts.BasicNumericTickProviderSpec(
              desiredTickCount: 6, desiredMaxTickCount: 10)),
      domainAxis: const charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 8,
          ),
          labelRotation: 45,
        ),
      ),
      behaviors: [
        charts.ChartTitle('Data Kota',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleStyleSpec: const charts.TextStyleSpec(fontSize: 12),
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        charts.ChartTitle('Data Kebutuhan & Ketersediaan',
            behaviorPosition: charts.BehaviorPosition.start,
            titleStyleSpec: const charts.TextStyleSpec(fontSize: 12),
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        charts.ChartTitle(labelSecondary,
            behaviorPosition: charts.BehaviorPosition.end,
            titleStyleSpec: const charts.TextStyleSpec(fontSize: 12),
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
      ],
      customSeriesRenderers: [
        charts.BarRendererConfig(customRendererId: 'customBar')
      ],
    );
  }
}

class HistogramData {
  final String kota;
  final num value;

  HistogramData(this.kota, this.value);
}
