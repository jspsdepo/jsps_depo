import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jsps_depo/pages/notes/add_note.dart';
import 'package:jsps_depo/pages/notes/edit_note.dart';
import 'package:jsps_depo/pages/notes/note_card.dart';

import 'package:shared_preferences/shared_preferences.dart';

class NotListScreen extends StatefulWidget {
  const NotListScreen({super.key});

  @override
  _NotListScreenState createState() => _NotListScreenState();
}

class _NotListScreenState extends State<NotListScreen> {
  bool selectionMode = false;
  final Random _random = Random();
  final Map<String, Color> cardColors = {};

  @override
  void initState() {
    super.initState();
    _loadColors();
  }

  Future<void> _loadColors() async {
    final prefs = await SharedPreferences.getInstance();
    final colorsString = prefs.getString('cardColors') ?? '{}';
    final Map<String, dynamic> colorsMap =
        json.decode(colorsString) as Map<String, dynamic>;
    setState(() {
      cardColors.clear();
      colorsMap.forEach((key, value) {
        cardColors[key] = Color(value as int);
      });
    });
  }

  Future<void> _saveColors() async {
    final prefs = await SharedPreferences.getInstance();
    final colorsMap =
        cardColors.map((key, value) => MapEntry(key, value.value));
    final colorsString = json.encode(colorsMap);
    await prefs.setString('cardColors', colorsString);
  }

  Color _getRandomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    );
  }

  Color _getColorForNoteId(String noteId) {
    if (!cardColors.containsKey(noteId)) {
      cardColors[noteId] = _getRandomColor();
      _saveColors();
    }
    return cardColors[noteId]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notlarım'),
        leading: selectionMode
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selectionMode = false;
                  });
                },
              )
            : null,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('notes')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          for (final doc in snapshot.data!.docs) {
            _getColorForNoteId(doc.id);
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Ekranda iki kutu olacak şekilde
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1, // Kutu boyutunu ayarlamak için
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final color = cardColors[doc.id]!;
              return GestureDetector(
                onLongPress: () {
                  setState(() {
                    selectionMode = true;
                  });
                },
                onTap: selectionMode
                    ? () {
                        setState(() {
                          selectionMode = false;
                        });
                      }
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditNoteScreen(note: doc),
                          ),
                        );
                      },
                child: NoteCard(
                  note: doc,
                  selectionMode: selectionMode,
                  color: color,
                  onDelete: () {
                    _showDeleteConfirmationDialog(doc);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNoteScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(DocumentSnapshot doc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Silme Onayı'),
          content: const Text('Bu notu silmek istediğinizden emin misiniz?'),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sil'),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('notes')
                    .doc(doc.id)
                    .delete();
                setState(() {
                  cardColors
                      .remove(doc.id); // Renk map'inden silinen notu kaldır
                  _saveColors();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
