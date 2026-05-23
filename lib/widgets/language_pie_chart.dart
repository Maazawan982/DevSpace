import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/github_repo.dart';

class LanguagePieChart extends StatelessWidget {
  final List<GitHubRepo> repos;

  const LanguagePieChart({super.key, required this.repos});

  @override
  Widget build(BuildContext context) {
    final Map<String, int> counts = {};
    for (final r in repos) {
      final lang = r.language ?? 'Unknown';
      counts[lang] = (counts[lang] ?? 0) + 1;
    }

    final total = counts.values.fold<int>(0, (a, b) => a + b);
    if (total == 0) {
      return const Center(child: Text('No repositories to analyze'));
    }

    final colors = <Color>[
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.brown,
    ];

    final entries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final sections = <PieChartSectionData>[];
    for (var i = 0; i < entries.length; i++) {
      final e = entries[i];
      final percent = e.value / total * 100;
      sections.add(PieChartSectionData(
        color: colors[i % colors.length],
        value: e.value.toDouble(),
        title: '${percent.toStringAsFixed(0)}%',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sections: sections,
              sectionsSpace: 2,
              centerSpaceRadius: 48,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: List.generate(entries.length, (i) {
            final e = entries[i];
            final color = colors[i % colors.length];
            final percent = e.value / total * 100;
            return Chip(
              backgroundColor: color.withOpacity(0.15),
              label: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(width:10,height:10,decoration: BoxDecoration(color: color,borderRadius: BorderRadius.circular(3))),
                const SizedBox(width:6),
                Text('${e.key} • ${percent.toStringAsFixed(1)}%'),
              ]),
            );
          }),
        )
      ],
    );
  }
}
