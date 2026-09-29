import 'package:flutter/material.dart';
import '../../models/subject.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  final List<Subject> _subjects = [
    Subject(
        id: '1',
        name: 'Mathematics',
        color: const Color(0xFF6C63FF),
        icon: Icons.calculate_outlined,
        totalChapters: 12,
        completedChapters: 7),
    Subject(
        id: '2',
        name: 'Physics',
        color: const Color(0xFF00D9A5),
        icon: Icons.science_outlined,
        totalChapters: 10,
        completedChapters: 4),
    Subject(
        id: '3',
        name: 'Chemistry',
        color: const Color(0xFFFFB84D),
        icon: Icons.biotech_outlined,
        totalChapters: 8,
        completedChapters: 6),
    Subject(
        id: '4',
        name: 'Biology',
        color: const Color(0xFFFF5C5C),
        icon: Icons.eco_outlined,
        totalChapters: 15,
        completedChapters: 9),
    Subject(
        id: '5',
        name: 'Computer Science',
        color: const Color(0xFF4ECDC4),
        icon: Icons.computer_outlined,
        totalChapters: 10,
        completedChapters: 3),
  ];

  void _showAddSubjectDialog() {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Subject'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Subject name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _subjects.add(Subject(
                    id: DateTime.now().toString(),
                    name: nameController.text,
                    color: Colors.primaries[
                        _subjects.length % Colors.primaries.length],
                    icon: Icons.book_outlined,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subjects')),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSubjectDialog,
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _subjects.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final subject = _subjects[i];
          return _SubjectCard(subject: subject);
        },
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final Subject subject;
  const _SubjectCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252540) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: subject.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(subject.icon, color: subject.color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subject.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      '${subject.completedChapters}/${subject.totalChapters} chapters',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Text(
                '${(subject.progress * 100).toInt()}%',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: subject.color),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: subject.progress,
              minHeight: 8,
              backgroundColor: subject.color.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation(subject.color),
            ),
          ),
        ],
      ),
    );
  }
}