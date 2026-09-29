import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int _selectedRange = 1;
  final List<String> _ranges = ['Day', 'Week', 'Month'];

  final Map<String, List<double>> _weekData = {
    'Week': [1.5, 3.2, 2.1, 4.5, 3.8, 2.0, 4.2],
  };

  final List<String> _dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  final List<_SubjectProgress> _subjectProgress = [
    _SubjectProgress('Mathematics', 0.75, const Color(0xFF6C63FF)),
    _SubjectProgress('Physics', 0.45, const Color(0xFF00D9A5)),
    _SubjectProgress('Chemistry', 0.82, const Color(0xFFFFB84D)),
    _SubjectProgress('Biology', 0.60, const Color(0xFFFF5C5C)),
    _SubjectProgress('Computer Science', 0.35, const Color(0xFF4ECDC4)),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final data = _weekData['Week'] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('This Week',
                      style: TextStyle(
                          color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 8),
                  const Text('21.5 hours',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.arrow_upward,
                          color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text('12% from last week',
                          style: TextStyle(
                              color: Colors.white, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildFilterRow(),
            const SizedBox(height: 16),
            _buildBarChart(data, isDark),
            const SizedBox(height: 28),
            const Text('Subject Progress',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            ..._subjectProgress.map((s) => _buildSubjectRow(s)),
            const SizedBox(height: 24),
            const Text('Achievements',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            _buildAchievements(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      children: List.generate(_ranges.length, (i) {
        final isSelected = _selectedRange == i;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(_ranges[i]),
            selected: isSelected,
            onSelected: (_) => setState(() => _selectedRange = i),
          ),
        );
      }),
    );
  }

  Widget _buildBarChart(List<double> data, bool isDark) {
    final maxVal = data.isEmpty
        ? 1.0
        : data.reduce((a, b) => a > b ? a : b);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252540) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        height: 200,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(data.length, (i) {
            final ratio = data[i] / maxVal;
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${data[i]}h',
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade600)),
                const SizedBox(height: 6),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  width: 28,
                  height: 140 * ratio,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.5),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(_dayLabels[i],
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade600)),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSubjectRow(_SubjectProgress s) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(s.name,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('${(s.progress * 100).toInt()}%',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: s.color)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: s.progress,
              minHeight: 8,
              backgroundColor: s.color.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation(s.color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements(bool isDark) {
    final items = [
      _Achievement('First Steps', Icons.emoji_events, const Color(0xFFFFB84D)),
      _Achievement('Week Warrior', Icons.local_fire_department,
          const Color(0xFFFF5C5C)),
      _Achievement('Focused', Icons.center_focus_strong,
          const Color(0xFF00D9A5)),
      _Achievement('Scholar', Icons.school, const Color(0xFF6C63FF)),
    ];
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final a = items[i];
          return Container(
            width: 100,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF252540) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: a.color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(a.icon, color: a.color, size: 24),
                ),
                const SizedBox(height: 8),
                Text(a.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SubjectProgress {
  final String name;
  final double progress;
  final Color color;
  _SubjectProgress(this.name, this.progress, this.color);
}

class _Achievement {
  final String name;
  final IconData icon;
  final Color color;
  _Achievement(this.name, this.icon, this.color);
}