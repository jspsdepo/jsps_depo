import 'package:flutter/material.dart';
import 'package:jsps_depo/pages/notes/note_form.dart';

class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not Ekle'),
      ),
      body: const NoteForm(),
    );
  }
}
