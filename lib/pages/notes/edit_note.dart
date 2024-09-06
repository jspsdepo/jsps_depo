import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jsps_depo/pages/notes/note_form.dart';

class EditNoteScreen extends StatelessWidget {
  final DocumentSnapshot note;

  const EditNoteScreen({required this.note, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not Düzenle'),
      ),
      body: NoteForm(note: note),
    );
  }
}
