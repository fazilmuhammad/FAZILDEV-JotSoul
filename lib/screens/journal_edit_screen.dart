import 'package:flutter/material.dart';
import 'package:jotsoul/helper/database_helper.dart';
import 'package:jotsoul/models/journal_entry.dart';

class JournalEditScreen extends StatefulWidget {
  final JournalEntry? entry;

  const JournalEditScreen({super.key, this.entry});

  @override
  State<JournalEditScreen> createState() => _JournalEditScreenState();
}

class _JournalEditScreenState extends State<JournalEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _title = widget.entry?.title ?? '';
    _content = widget.entry?.content ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'New Entry' : 'Edit Entry'),
        actions: [
          if (widget.entry != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteEntry,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _content,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some content';
                  }
                  return null;
                },
                onSaved: (value) => _content = value!,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Save'),
                onPressed: _saveEntry,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveEntry() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final entry = JournalEntry(
        id: widget.entry?.id,
        title: _title,
        content: _content,
      );

      if (widget.entry == null) {
        await _dbHelper.create(entry);
      } else {
        await _dbHelper.update(entry);
      }

      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  Future<void> _deleteEntry() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text('Are you sure you want to delete this entry?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await _dbHelper.delete(widget.entry!.id);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }
}