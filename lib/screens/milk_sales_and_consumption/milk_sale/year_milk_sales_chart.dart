import 'package:DigitalDairy/controllers/year_milk_sales_controller.dart';
import 'package:DigitalDairy/util/utils.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class YearMilkSaleChart extends StatelessWidget {
  YearMilkSaleChart({super.key});
  late Map<int, double> yearMilkSaleList;

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

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Colors.blue,
          Colors.cyanAccent,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => yearMilkSaleList.entries
      .mapIndexed(
        (index, monthMilkSale) => BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: monthMilkSale.value,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    yearMilkSaleList =
        context.watch<YearMilkSalesController>().yearYearMilkSalesList;
    return SizedBox(
        width: 500,
        height: 500,
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
                              color: Colors.cyanAccent,
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
                      axisNameWidget: const Text("Money (Ksh)"),
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
