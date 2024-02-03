import 'package:DigitalDairy/util/utils.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class YearMilkProductionChart extends StatefulWidget {
  const YearMilkProductionChart(
      {super.key, required this.yearMilkProductionList});
  final Map<int, double> yearMilkProductionList;

  @override
  State<StatefulWidget> createState() => YearMilkProductionChartState();
}

class YearMilkProductionChartState extends State<YearMilkProductionChart> {
  final List<String> monthsOfYear = MonthsOfTheYear.values
      .map((monthOfYear) => monthOfYear.monthName)
      .toList();

  Widget bottomTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    const style = TextStyle(
      fontSize: 12,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child:
          Text(monthsOfYear.elementAtOrNull(value.toInt()) ?? '', style: style),
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

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Colors.blue,
          Colors.cyanAccent,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => widget.yearMilkProductionList.entries
      .mapIndexed(
        (index, monthMilkProduction) => BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: monthMilkProduction.value,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [index],
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
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
                      axisNameWidget: const Text("Months of the Year"),
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
