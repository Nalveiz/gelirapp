import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class IncomeExpensePieChart extends StatelessWidget {
  final double income;
  final double expense;

  const IncomeExpensePieChart({
    super.key,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final total = income + expense.abs();
    if (total == 0) {
      return const Text("No data to show.");
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 200,
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                value: income,
                color: Colors.green,
                title: '${((income / total) * 100).toStringAsFixed(1)}%',
                radius: 60,
                titleStyle: const TextStyle(color: Colors.white),
              ),
              PieChartSectionData(
                value: expense.abs(),
                color: Colors.red,
                title: '${((expense.abs() / total) * 100).toStringAsFixed(1)}%',
                radius: 60,
                titleStyle: const TextStyle(color: Colors.white),
              ),
            ],
            sectionsSpace: 0,
            centerSpaceRadius: 40,
          ),
        ),
      ),
    );
  }
}
