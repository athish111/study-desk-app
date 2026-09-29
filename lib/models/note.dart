class Note {
  final String id;
  final String title;
  final String content;
  final String subjectId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.subjectId,
    required this.createdAt,
    required this.updatedAt,
  });
}