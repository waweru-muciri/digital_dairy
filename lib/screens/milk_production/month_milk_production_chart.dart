import 'dart:math';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DailyMilkProductionChart extends StatefulWidget {
  const DailyMilkProductionChart(
      {super.key, required this.monthDailyMilkProductionList});
  final Map<String, double> monthDailyMilkProductionList;

  @override
  State<StatefulWidget> createState() => DailyMilkProductionChartState();
}

class DailyMilkProductionChartState extends State<DailyMilkProductionChart> {
  late List<String> daysOfMonth;
  late List<FlSpot> spots;

  @override
  void initState() {
    spots = widget.monthDailyMilkProductionList.entries
        .mapIndexed((index, dailyMilkProduction) =>
            FlSpot(index.toDouble(), dailyMilkProduction.value))
        .toList();
    daysOfMonth = widget.monthDailyMilkProductionList.keys
        .map((e) => e.substring(0, 2))
        .toList();
    super.initState();
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    const style = TextStyle(
      fontSize: 12,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child:
          Text(daysOfMonth.elementAtOrNull(value.toInt()) ?? '', style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    const style = TextStyle(
      fontSize: 12,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(meta.formattedValue, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: AspectRatio(
          aspectRatio: 1,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      maxContentWidth: 100,
                      tooltipBgColor: Colors.greenAccent,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          final textStyle = TextStyle(
                            color: touchedSpot.bar.gradient?.colors[0] ??
                                touchedSpot.bar.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          );
                          return LineTooltipItem(
                            '${touchedSpot.y.toStringAsFixed(2)} Kgs',
                            textStyle,
                          );
                        }).toList();
                      },
                    ),
                    handleBuiltInTouches: true,
                    getTouchLineStart: (data, index) => 0,
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      color: Colors.blue,
                      spots: spots,
                      isCurved: true,
                      isStrokeCapRound: true,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: false,
                      ),
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                  minY: 0,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      axisNameSize: 20,
                      axisNameWidget: const Text("Milk Quantity (Kgs)"),
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) =>
                            leftTitleWidgets(value, meta, constraints.maxWidth),
                        reservedSize: 56,
                      ),
                      drawBelowEverything: true,
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameSize: 20,
                      axisNameWidget: const Text("Days of the Month"),
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => bottomTitleWidgets(
                            value, meta, constraints.maxWidth),
                        interval: 1,
                      ),
                      drawBelowEverything: true,
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                ),
              );
            },
          ),
        ));
  }
}
