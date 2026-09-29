import 'package:flutter/material.dart';
import '../../models/task.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Complete Calculus Assignment',
      description: 'Solve problems 1-20 from chapter 5',
      dueDate: DateTime.now().add(const Duration(hours: 6)),
      priority: TaskPriority.high,
      subjectId: 'Mathematics',
    ),
    Task(
      id: '2',
      title: 'Read Physics Chapter 3',
      description: 'Newton\'s laws of motion',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: TaskPriority.medium,
      subjectId: 'Physics',
    ),
    Task(
      id: '3',
      title: 'Revise Chemistry Notes',
      description: 'Periodic table trends',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      priority: TaskPriority.low,
      subjectId: 'Chemistry',
      isCompleted: true,
    ),
    Task(
      id: '4',
      title: 'Biology Lab Report',
      description: 'Submit cell structure report',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      priority: TaskPriority.high,
      subjectId: 'Biology',
    ),
  ];

  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Pending', 'Completed'];

  List<Task> get _filteredTasks {
    switch (_selectedFilter) {
      case 1:
        return _tasks.where((t) => !t.isCompleted).toList();
      case 2:
        return _tasks.where((t) => t.isCompleted).toList();
      default:
        return _tasks;
    }
  }

  void _toggleTask(Task task) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        final t = _tasks[index];
        _tasks[index] = Task(
          id: t.id,
          title: t.title,
          description: t.description,
          dueDate: t.dueDate,
          isCompleted: !t.isCompleted,
          priority: t.priority,
          subjectId: t.subjectId,
        );
      }
    });
  }

  void _showAddTaskSheet() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    TaskPriority selectedPriority = TaskPriority.medium;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Add New Task',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Task title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: const InputDecoration(hintText: 'Description'),
              ),
              const SizedBox(height: 16),
              const Text('Priority',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: TaskPriority.values.map((p) {
                  final labels = ['Low', 'Medium', 'High'];
                  final colors = [
                    const Color(0xFF00D9A5),
                    const Color(0xFFFFB84D),
                    const Color(0xFFFF5C5C),
                  ];
                  final idx = p.index;
                  final isSelected = selectedPriority == p;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () =>
                            setSheetState(() => selectedPriority = p),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colors[idx].withOpacity(0.2)
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? colors[idx]
                                  : Colors.grey.shade400,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            labels[idx],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSelected ? colors[idx] : null,
                              fontWeight:
                                  isSelected ? FontWeight.bold : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      setState(() {
                        _tasks.add(Task(
                          id: DateTime.now().toString(),
                          title: titleController.text,
                          description: descController.text,
                          dueDate: DateTime.now().add(const Duration(days: 1)),
                          priority: selectedPriority,
                        ));
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add Task'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskSheet,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: List.generate(_filters.length, (i) {
                final isSelected = _selectedFilter == i;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_filters[i]),
                    selected: isSelected,
                    onSelected: (_) =>
                        setState(() => _selectedFilter = i),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _filteredTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt,
                            size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text('No tasks found',
                            style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                    itemCount: _filteredTasks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final task = _filteredTasks[i];
                      return _TaskCard(
                        task: task,
                        onToggle: () => _toggleTask(task),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  const _TaskCard({required this.task, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252540) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: task.priorityColor, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: task.isCompleted
                    ? task.priorityColor
                    : Colors.transparent,
                border: Border.all(
                  color: task.isCompleted
                      ? task.priorityColor
                      : Colors.grey.shade400,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: task.isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: task.isCompleted ? Colors.grey : null,
                  ),
                ),
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    task.description,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        size: 12, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      _formatDueDate(task.dueDate),
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade600),
                    ),
                    if (task.subjectId != null) ...[
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: task.priorityColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          task.subjectId!,
                          style: TextStyle(
                            fontSize: 10,
                            color: task.priorityColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now);
    if (diff.inHours < 1) return 'Due soon';
    if (diff.inHours < 24) return 'Due in ${diff.inHours}h';
    if (diff.inDays < 7) return 'Due in ${diff.inDays}d';
    return '${date.day}/${date.month}/${date.year}';
  }
}