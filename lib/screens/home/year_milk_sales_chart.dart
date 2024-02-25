import 'package:DigitalDairy/util/utils.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class YearMilkSalesChart extends StatelessWidget {
  const YearMilkSalesChart({super.key, required this.yearMilkSalesList});
  final Map<int, double> yearMilkSalesList;

  Widget bottomTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    const style = TextStyle(
      fontSize: 12,
    );
    return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Transform.rotate(
          angle: -math.pi / 4,
          child: Text(
              namesOfMonthsInYearList.elementAtOrNull(value.toInt()) ?? '',
              style: style),
        ));
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

  Color get getRandomColor =>
      Color((math.Random().nextDouble() * 0xFFFFFF).toInt());

  LinearGradient barsGradient() {
    final Color barsColor = getRandomColor;
    return LinearGradient(
      colors: [
        barsColor.withOpacity(0.2),
        barsColor.withOpacity(1.0),
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );
  }

  List<BarChartGroupData> get barGroups => yearMilkSalesList.entries
      .mapIndexed(
        (index, monthMilkSales) => BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              width: 18,
              toY: monthMilkSales.value,
              gradient: barsGradient(),
            )
          ],
          showingTooltipIndicators: [0],
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 600,
        height: 600,
        child: AspectRatio(
          aspectRatio: 1,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                        maxContentWidth: 100,
                        tooltipBgColor: Colors.transparent,
                        tooltipPadding: EdgeInsets.zero,
                        tooltipMargin: 8,
                        getTooltipItem: (
                          BarChartGroupData group,
                          int groupIndex,
                          BarChartRodData rod,
                          int rodIndex,
                        ) {
                          return BarTooltipItem(
                            rod.toY.round().toString(),
                            const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                    handleBuiltInTouches: true,
                  ),
                  barGroups: barGroups,
                  minY: 0,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      axisNameSize: 20,
                      axisNameWidget: const Text("Sales (Kshs)"),
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) =>
                            leftTitleWidgets(value, meta, constraints.maxWidth),
                        reservedSize: 50,
                      ),
                      drawBelowEverything: true,
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameSize: 20,
                      axisNameWidget: const Text("Months of the Year"),
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => bottomTitleWidgets(
                            value, meta, constraints.maxWidth),
                        reservedSize: 50,
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
