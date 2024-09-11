import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coordinate_converter/coordinate_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jsps_depo/themes/box_decoration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({super.key});

  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  Position? _currentPosition;
  DDCoordinates? _ddCoordinates;
  DMSCoordinates? _dmsCoordinates;
  UTMCoordinates? _utmCoordinates;
  String? _wgs84Coordinates;
  final List<Map<String, String>> _coordinateList = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadCoordinates();
  }

  Future<void> _loadCoordinates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedCoordinates = prefs.getStringList('coordinates');
    setState(() {
      _coordinateList.addAll(
        savedCoordinates!.map((coord) {
          Map<String, dynamic> decoded =
              jsonDecode(coord) as Map<String, dynamic>;
          return decoded.map((key, value) => MapEntry(key, value.toString()));
        }).toList(),
      );
    });

    try {
      CollectionReference coordinates =
          FirebaseFirestore.instance.collection('coordinates');
      QuerySnapshot querySnapshot = await coordinates.get();
      setState(() {
        _coordinateList.clear();
        _coordinateList.addAll(
          querySnapshot.docs.map((doc) {
            final data = doc.data()! as Map<String, dynamic>;
            return {
              'name': data['name'] as String,
              'wgs84Coordinate': data['wgs84Coordinate'] as String,
              'dmsCoordinate': data['dmsCoordinate'] as String,
              'utmCoordinate': data['utmCoordinate'] as String,
            };
          }).toList(),
        );
      });
    } catch (e) {
      print("Firestore'dan verileri yüklerken hata: $e");
    }
  }

  Future<void> _saveCoordinates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> coordinatesToSave =
        _coordinateList.map((coord) => jsonEncode(coord)).toList();
    await prefs.setStringList('coordinates', coordinatesToSave);
  }

  Future<void> _addCoordinateToFirestore(Map<String, String> coord) async {
    try {
      CollectionReference coordinates =
          FirebaseFirestore.instance.collection('coordinates');
      await coordinates.add(coord);
    } catch (e) {
      print("Firestore'a veri eklerken hata: $e");
    }
  }

  Future<void> _updateCoordinateInFirestore(
    String oldName,
    Map<String, String> updatedCoord,
  ) async {
    try {
      CollectionReference coordinates =
          FirebaseFirestore.instance.collection('coordinates');
      QuerySnapshot querySnapshot =
          await coordinates.where('name', isEqualTo: oldName).get();
      for (final QueryDocumentSnapshot doc in querySnapshot.docs) {
        await coordinates.doc(doc.id).update(updatedCoord);
      }
    } catch (e) {
      print("Firestore'da veri güncellerken hata: $e");
    }
  }

  Future<void> _deleteCoordinateFromFirestore(String name) async {
    try {
      CollectionReference coordinates =
          FirebaseFirestore.instance.collection('coordinates');
      QuerySnapshot querySnapshot =
          await coordinates.where('name', isEqualTo: name).get();
      for (final QueryDocumentSnapshot doc in querySnapshot.docs) {
        await coordinates.doc(doc.id).delete();
      }
    } catch (e) {
      print("Firestore'dan veri silerken hata: $e");
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Konum servisleri devre dışı.';
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Konum izinleri reddedildi';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Konum izinleri kalıcı olarak reddedildi, izin talep edemiyoruz.';
      }

      final position = await Geolocator.getCurrentPosition();
      final ddCoordinates = DDCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      final dmsCoordinates = ddCoordinates.toDMS();
      final utmCoordinates = ddCoordinates.toUTM();
      final wgs84Coordinates = '${position.latitude}, ${position.longitude}';
      final newCoord = {
        'name': 'Koordinat ${_coordinateList.length + 1}',
        'wgs84Coordinate': wgs84Coordinates,
        'dmsCoordinate': dmsCoordinates.toString(),
        'utmCoordinate': utmCoordinates.toString(),
      };

      await _addCoordinateToFirestore(newCoord);
      await _saveCoordinates();

      setState(() {
        _currentPosition = position;
        _ddCoordinates = ddCoordinates;
        _dmsCoordinates = dmsCoordinates;
        _utmCoordinates = utmCoordinates;
        _wgs84Coordinates = wgs84Coordinates;
        _coordinateList.insert(
          0,
          newCoord,
        ); // En üste eklemek için değiştirildi
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata: $e'),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Tekrar Dene',
            onPressed: _determinePosition,
          ),
        ),
      );
    }
  }

  void _copyAllCoordinates(int index) {
    if (index < 0 || index >= _coordinateList.length) return;

    String coordinates = '''
WGS84: ${_coordinateList[index]['wgs84Coordinate']}
DMS: ${_coordinateList[index]['dmsCoordinate']}
UTM: ${_coordinateList[index]['utmCoordinate']}
    ''';
    Clipboard.setData(ClipboardData(text: coordinates));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tüm koordinat formatları panoya kopyalandı'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _deleteCoordinate(int index) async {
    if (index < 0 || index >= _coordinateList.length) {
      print("Geçersiz indeks: $index");
      return;
    }

    String name = _coordinateList[index]['name']!;
    try {
      await _deleteCoordinateFromFirestore(name);
      setState(() {
        _coordinateList.removeAt(index);
      });
      await _saveCoordinates(); // Koordinat silindiğinde güncelle
    } catch (error) {
      print("Hata: $error");
    }
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Koordinatı Sil'),
          content:
              const Text('Bu koordinatı silmek istediğinizden emin misiniz?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialogu kapat
              },
              child: const Text('Hayır'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialogu kapat
                _deleteCoordinate(index); // Koordinatı sil
              },
              child: const Text('Evet'),
            ),
          ],
        );
      },
    );
  }

  void _editCoordinateName(BuildContext context, int index) {
    if (index < 0 || index >= _coordinateList.length) return;

    final TextEditingController controller =
        TextEditingController(text: _coordinateList[index]['']);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('İsmi Düzenle'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Yeni isim giriniz'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                String oldName = _coordinateList[index]['name']!;
                Map<String, String> updatedCoord = {
                  ..._coordinateList[index],
                  'name': controller.text,
                };
                _updateCoordinateInFirestore(oldName, updatedCoord).then((_) {
                  setState(() {
                    _coordinateList[index]['name'] = controller.text;
                    _saveCoordinates();
                  });
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Koordinat Al'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _coordinateList.length,
                itemBuilder: (context, index) {
                  return _buildCoordinateCard(index);
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _determinePosition,
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Koordinat Güncelle'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoordinateRow(String title, String? coordinate, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            coordinate!,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: coordinate));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$title kopyalandı'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCoordinateCard(int index) {
    if (index < 0 || index >= _coordinateList.length) {
      return const SizedBox.shrink();
    }

    final coordinate = _coordinateList[index];
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: CustomBoxTheme.getBoxShadowDecoration(Theme.of(context)),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Koordinat: ${coordinate['name']}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildCoordinateRow('WGS84:', coordinate['wgs84Coordinate'], index),
            const SizedBox(height: 8),
            _buildCoordinateRow('DMS:', coordinate['dmsCoordinate'], index),
            const SizedBox(height: 8),
            _buildCoordinateRow('UTM:', coordinate['utmCoordinate'], index),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _editCoordinateName(context, index);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _confirmDelete(index);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
