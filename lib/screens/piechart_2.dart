import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class IncomeExpensePieChart2 extends StatelessWidget {
  final double income;
  final double expense;

  const IncomeExpensePieChart2({
    super.key,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: income,
              color: Colors.green,
              title: 'Income',
              radius: 60,
              titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            PieChartSectionData(
              value: expense.abs(), // Negatifse pozitif yap
              color: Colors.red,
              title: 'Expense',
              radius: 60,
              titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }
}
