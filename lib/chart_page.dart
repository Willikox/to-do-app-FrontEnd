import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartPage extends StatelessWidget {
  final int completedCount;
  final int notCompletedCount;
  final int deletedCount;

  // ignore: use_super_parameters
  const ChartPage({
    Key? key,
    required this.completedCount,
    required this.notCompletedCount,
    required this.deletedCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = [];
    if (completedCount > 0) {
      sections.add(
        PieChartSectionData(
          value: completedCount.toDouble(),
          title: 'Completadas = $completedCount',
          color: Colors.lightBlue,
          radius: 80,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );
    }
    if (notCompletedCount > 0) {
      sections.add(
        PieChartSectionData(
          value: notCompletedCount.toDouble(),
          title: 'No completadas = $notCompletedCount',
          color: Colors.amber,
          radius: 80,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );
    }
    if (deletedCount > 0) {
      sections.add(
        PieChartSectionData(
          value: deletedCount.toDouble(),
          title: 'Eliminadas = $deletedCount',
          color: Colors.red,
          radius: 80,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grafica de Tareas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Pastel',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: sections,
                  sectionsSpace: 4,
                  centerSpaceRadius: 50,
                  startDegreeOffset: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
