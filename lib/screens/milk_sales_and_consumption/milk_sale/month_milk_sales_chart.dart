import 'package:DigitalDairy/controllers/monthly_milk_sales_controller.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthMilkSaleChart extends StatelessWidget {
  MonthMilkSaleChart({super.key});

  late List<String> daysOfMonth;
  late List<FlSpot> spots;
  late Map<String, double> monthDailyMilkSaleList;

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
    monthDailyMilkSaleList =
        context.watch<MonthlyMilkSaleController>().eachMonthMilkSalesGraphData;
    spots = monthDailyMilkSaleList.entries
        .mapIndexed((index, dailyMilkSale) =>
            FlSpot(index.toDouble(), dailyMilkSale.value))
        .toList();
    daysOfMonth = monthDailyMilkSaleList.keys
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
                            '${touchedSpot.y.toStringAsFixed(2)} Ksh',
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
                      axisNameWidget: const Text("Money (Ksh)"),
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
