import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show Clipboard, ClipboardData, rootBundle;
import 'package:jsps_depo/base_state.dart';
import 'package:jsps_depo/jsps_depom_icons.dart';
import 'package:jsps_depo/pages/json_screen/highlight_text.dart';
import 'package:jsps_depo/themes/box_decoration.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends BaseState<DictionaryScreen> {
  Map<String, List<String>> terms = {};
  Map<String, List<String>> filteredTerms = {};
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  bool isSearching = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadTerms();
    searchController.addListener(_filterTerms);
  }

  Future<void> loadTerms() async {
    String jsonString = await rootBundle.loadString('assets/terms.json');
    final Map<String, dynamic> jsonMap =
        json.decode(jsonString) as Map<String, dynamic>;
    setState(() {
      terms = jsonMap.map((key, value) {
        List<String> filteredList =
            List<String>.from(value as Iterable).toList();
        return MapEntry(key, filteredList);
      });
      filteredTerms = Map.from(terms);
    });
  }

  void _filterTerms() {
    String query = searchController.text.toLowerCase();
    setState(() {
      searchQuery = query;
    });
    if (query.isEmpty) {
      setState(() {
        filteredTerms = Map.from(terms);
      });
      return;
    }

    Map<String, List<String>> tempFilteredTerms = {};
    terms.forEach((key, value) {
      List<String> filteredList =
          value.where((term) => term.toLowerCase().contains(query)).toList();
      if (filteredList.isNotEmpty) {
        tempFilteredTerms[key] = filteredList;
      }
    });

    setState(() {
      filteredTerms = tempFilteredTerms;
    });
  }

  void _toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      searchController.clear();
      filteredTerms = Map.from(terms);
    });
  }

  Future<bool> _onWillPop() async {
    if (isSearching) {
      _toggleSearch();
      return false; // Geri tuşuna basıldığında uygulamadan çıkmaz, sadece aramadan çıkar
    }
    return true; // Geri tuşuna basıldığında önceki sayfaya gider
  }

  void _copyToClipboard(String termTitle, String termDescription) {
    Clipboard.setData(ClipboardData(text: '$termTitle: $termDescription'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Metin kopyalandı')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: DefaultTabController(
        length: filteredTerms.keys.length,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: isSearching
                ? TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Ara...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                : const Text('TÜRKÇE SÖZLÜK'),
            actions: [
              if (isSearching)
                IconButton(
                  icon: const Icon(JspsDepom.search),
                  onPressed: _toggleSearch,
                )
              else
                IconButton(
                  icon: const Icon(JspsDepom.search),
                  onPressed: _toggleSearch,
                ),
            ],
            bottom: TabBar(
              isScrollable: true,
              tabs: filteredTerms.keys
                  .map((letter) => Tab(text: letter))
                  .toList(),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: filteredTerms.keys.map((letter) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: filteredTerms[letter]?.length ?? 0,
                      itemBuilder: (context, index) {
                        final term = filteredTerms[letter]?[index] ?? '';
                        final termParts = term.split(':');
                        final termTitle = termParts[0].replaceFirst(
                          termParts[0][0],
                          termParts[0][0].toUpperCase(),
                        );
                        final termDescription = termParts.length > 1
                            ? termParts.sublist(1).join(':').trim()
                            : '';
                        return Padding(
                          padding: const EdgeInsets.all(2),
                          child: InkWell(
                            onLongPress: () =>
                                _copyToClipboard(termTitle, termDescription),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                decoration:
                                    CustomBoxTheme.getBoxShadowDecoration(
                                  Theme.of(context),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: highlightText(
                                          termTitle,
                                          searchQuery,
                                          index,
                                          isDarkTheme,
                                          20,
                                        ),
                                      ),
                                      Text(
                                        'Açıklama:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isDarkTheme
                                              ? Colors.white70
                                              : Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        termDescription,
                                        style: TextStyle(
                                          color: isDarkTheme
                                              ? Colors.white70
                                              : Colors.black87,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
