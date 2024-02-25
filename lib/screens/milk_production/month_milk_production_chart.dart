import 'package:DigitalDairy/controllers/monthly_milk_production_controller.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DailyMilkProductionChart extends StatelessWidget {
  DailyMilkProductionChart({super.key});

  late List<String> daysOfMonth;
  late List<FlSpot> spots;
  late Map<String, double> monthDailyMilkProductionList;

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

  LinearGradient get _lineGradient => LinearGradient(
        colors: [
          Colors.greenAccent.withOpacity(0.2),
          Colors.greenAccent.withOpacity(1.0),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  @override
  Widget build(BuildContext context) {
    monthDailyMilkProductionList = context
        .watch<MonthlyMilkProductionController>()
        .monthDailyMilkProductionsList;
    spots = monthDailyMilkProductionList.entries
        .mapIndexed((index, dailyMilkProduction) =>
            FlSpot(index.toDouble(), dailyMilkProduction.value))
        .toList();
    daysOfMonth = monthDailyMilkProductionList.keys
        .map((e) => e.split('/').lastOrNull ?? '')
        .toList();
    return SizedBox(
        width: 800,
        height: 500,
        child: AspectRatio(
          aspectRatio: 1.6,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      maxContentWidth: 100,
                      tooltipBgColor: Colors.lightGreen,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          const textStyle = TextStyle(
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
                      color: Colors.greenAccent,
                      spots: spots,
                      isCurved: true,
                      isStrokeCapRound: true,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                          show: true,
                          color: Colors.greenAccent,
                          gradient: _lineGradient),
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
                          reservedSize: 32),
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
