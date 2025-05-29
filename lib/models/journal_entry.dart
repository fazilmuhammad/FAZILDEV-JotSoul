import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class JournalEntry {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final int wordCount;

  JournalEntry({
    String? id,
    required this.title,
    required this.content,
    int? wordCount,
    DateTime? date,
  })  : id = id ?? const Uuid().v4(),
        date = date ?? DateTime.now(),
        wordCount = wordCount ?? content.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'wordCount': wordCount,
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: DateTime.parse(map['date']),
      wordCount: map['wordCount'] ?? (map['content']?.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length ?? 0,
     ) );
  }

  String get formattedDate {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}