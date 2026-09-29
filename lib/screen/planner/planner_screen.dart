import 'package:flutter/material.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  DateTime _selectedDate = DateTime.now();
  final DateTime _focusedMonth = DateTime.now();

  final Map<int, List<_PlanEvent>> _events = {
    DateTime.now().day: [
      _PlanEvent('Study Math', '10:00 AM', const Color(0xFF6C63FF)),
      _PlanEvent('Physics Lab', '2:00 PM', const Color(0xFF00D9A5)),
      _PlanEvent('Read Notes', '6:00 PM', const Color(0xFFFFB84D)),
    ],
    DateTime.now().day + 1: [
      _PlanEvent('Chemistry Class', '9:00 AM', const Color(0xFFFF5C5C)),
      _PlanEvent('Math Test', '11:00 AM', const Color(0xFF6C63FF)),
    ],
    DateTime.now().day + 3: [
      _PlanEvent('Biology Study', '4:00 PM', const Color(0xFF4ECDC4)),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final todayEvents = _events[_selectedDate.day] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddEventDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCalendar(context, isDark),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  'Events on ${_selectedDate.day}/${_selectedDate.month}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '${todayEvents.length} events',
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Expanded(
            child: todayEvents.isEmpty
                ? _buildEmptyState(isDark)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: todayEvents.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, i) =>
                        _EventCard(event: todayEvents[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(BuildContext context, bool isDark) {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final startWeekday = firstDay.weekday % 7;
    final totalCells = startWeekday + daysInMonth;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      color: isDark ? const Color(0xFF252540) : Colors.white,
      child: Column(
        children: [
          Text(
            _monthName(_focusedMonth.month) + ' ${_focusedMonth.year}',
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                .map((d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: totalCells,
            itemBuilder: (context, i) {
              if (i < startWeekday) return const SizedBox();
              final day = i - startWeekday + 1;
              final isSelected = _selectedDate.day == day &&
                  _selectedDate.month == _focusedMonth.month;
              final isToday = DateTime.now().day == day &&
                  DateTime.now().month == _focusedMonth.month;
              final hasEvent = _events.containsKey(day);

              return GestureDetector(
                onTap: () => setState(() {
                  _selectedDate = DateTime(
                      _focusedMonth.year, _focusedMonth.month, day);
                }),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: isToday && !isSelected
                        ? Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 1.5)
                        : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected || isToday
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.white : Colors.black87),
                        ),
                      ),
                      if (hasEvent)
                        Positioned(
                          bottom: 4,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_note,
              size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text('No events scheduled',
              style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _showAddEventDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add Event'),
          ),
        ],
      ),
    );
  }

  void _showAddEventDialog() {
    final titleController = TextEditingController();
    final timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration:
                  const InputDecoration(hintText: 'Event title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(hintText: 'Time (e.g. 10:00 AM)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                setState(() {
                  _events.putIfAbsent(_selectedDate.day, () => []);
                  _events[_selectedDate.day]!.add(_PlanEvent(
                    titleController.text,
                    timeController.text.isEmpty
                        ? 'All day'
                        : timeController.text,
                    Colors.primaries[
                        _events[_selectedDate.day]!.length %
                            Colors.primaries.length],
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}

class _PlanEvent {
  final String title;
  final String time;
  final Color color;
  _PlanEvent(this.title, this.time, this.color);
}

class _EventCard extends StatelessWidget {
  final _PlanEvent event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252540) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: event.color, width: 4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: event.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.event, color: event.color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(event.time,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, size: 18),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}