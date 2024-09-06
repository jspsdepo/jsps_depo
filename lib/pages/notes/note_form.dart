import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoteForm extends StatefulWidget {
  final DocumentSnapshot? note;

  const NoteForm({super.key, this.note});

  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.get('title') as String;
      contentController.text = widget.note!.get('content') as String;
    }
  }

  void _saveNote() {
    if (widget.note == null) {
      // Add new note
      FirebaseFirestore.instance.collection('notes').add({
        'title': titleController.text,
        'content': contentController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      // Update existing note
      FirebaseFirestore.instance
          .collection('notes')
          .doc(widget.note!.id)
          .update({
        'title': titleController.text,
        'content': contentController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _saveNote();
        return true;
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Başlık',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Not başlığını girin',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'İçerik',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: TextField(
                controller: contentController,
                maxLines: null,
                minLines: 10, // Başlangıç boyutunu belirlemek için
                decoration: const InputDecoration(
                  hintText: 'Not içeriğini girin',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _saveNote();
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Text(
                    'Kaydet',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
