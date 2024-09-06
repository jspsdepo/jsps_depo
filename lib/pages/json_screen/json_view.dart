import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jsps_depo/jsps_depom_icons.dart';
import 'package:jsps_depo/pages/json_screen/highlight_text.dart';
import 'package:jsps_depo/themes/custom_color_scheme.dart';

class Jsonpdfviewer extends StatefulWidget {
  final String jsonString;
  final String fileName;

  const Jsonpdfviewer({
    required this.jsonString,
    required this.fileName,
    required String pdfUrl,
    required String folder,
    super.key,
  });

  @override
  _JsonpdfviewerState createState() => _JsonpdfviewerState();
}

class _JsonpdfviewerState extends State<Jsonpdfviewer>
    with TickerProviderStateMixin {
  List<Map<String, dynamic>> _pages = [];
  List<Map<String, dynamic>> _filteredPages = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final PageController _pageController = PageController();
  int _currentResultIndex = 0;
  final List<int> _resultIndexes = [];
  bool _isSearching = false;
  bool _isAppBarVisible = false; // Initially app bar is hidden
  int _currentMatchIndex = 0;
  late Future<void> _loadPagesFuture;
  Timer? _hideAppBarTimer;
  final Map<int, int> _searchCounts =
      {}; // Sayfalardaki arama sonuçlarının sayısı
  bool _hideAppBarPermanently = false; // AppBar gizle/göster durumu
  final TextEditingController _pageNumberController = TextEditingController();
  final TransformationController _transformationController =
      TransformationController();
  double _fontSize = 18; // Başlangıç yazı boyutu
  ThemeData _themeData = ThemeData.light(); // Default theme is light
  late AnimationController _animationController;
  late Animation<double> _fontSizeAnimation;

  bool _isSliderVisible = false; // Slider'ın görünürlüğü

  @override
  void initState() {
    super.initState();
    _loadPagesFuture = loadPages();
    _searchController.addListener(_filterPages);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _fontSizeAnimation =
        Tween<double>(begin: 18, end: _fontSize).animate(_animationController);
  }

  Future<void> loadPages() async {
    try {
      final jsonData = json.decode(widget.jsonString) as List<dynamic>;
      setState(() {
        _pages = jsonData.cast<Map<String, dynamic>>();
        _filteredPages = List.from(_pages);
      });
    } catch (error) {
      debugPrint('JSON yüklenirken hata oluştu: $error');
      setState(() {
        _filteredPages = [];
      });
    }
  }

  void _filterPages() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _searchQuery = query;
    });
    _resultIndexes.clear();
    _searchCounts.clear();

    if (query.isEmpty) {
      setState(() {
        _filteredPages = List.from(_pages);
      });
      return;
    }

    List<Map<String, dynamic>> tempFilteredPages = _pages
        .where((page) => (page['text'] as String).toLowerCase().contains(query))
        .toList();

    setState(() {
      _filteredPages = tempFilteredPages;
      _currentResultIndex = 0;
      _currentMatchIndex = 0;
    });

    for (int i = 0; i < _filteredPages.length; i++) {
      String text = _filteredPages[i]['text'] as String;
      int count = 0;
      int index = text.toLowerCase().indexOf(query);
      while (index != -1) {
        _resultIndexes.add(i);
        index = text.toLowerCase().indexOf(query, index + query.length);
        count++;
      }
      _searchCounts[i] = count; // Sayfadaki arama sonucu sayısını kaydedin
    }

    if (_resultIndexes.isNotEmpty && _pageController.hasClients) {
      _pageController.jumpToPage(_resultIndexes[_currentResultIndex]);
    }
  }

  void _nextResult() {
    if (_currentResultIndex < _resultIndexes.length - 1) {
      setState(() {
        _currentResultIndex++;
      });
      if (_pageController.hasClients) {
        _pageController.jumpToPage(_resultIndexes[_currentResultIndex]);
      }
    }
  }

  void _previousResult() {
    if (_currentResultIndex > 0) {
      setState(() {
        _currentResultIndex--;
      });
      if (_pageController.hasClients) {
        _pageController.jumpToPage(_resultIndexes[_currentResultIndex]);
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (_isSearching) {
      setState(() {
        _isSearching = false;
        _searchController.clear();
        _filteredPages = List.from(_pages);
      });
      return false;
    }
    return true;
  }

  void _scrollToCurrentResult() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentMatchIndex < _resultIndexes.length &&
          _resultIndexes[_currentMatchIndex] == _currentResultIndex) {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(_resultIndexes[_currentMatchIndex]);
        }
      }
    });
  }

  void _showAppBar() {
    setState(() {
      _isAppBarVisible = true;
    });
    _hideAppBarTimer?.cancel();
    if (!_isSearching && !_hideAppBarPermanently) {
      _hideAppBarTimer = Timer(const Duration(seconds: 3), () {
        setState(() {
          _isAppBarVisible = false;
        });
      });
    }
  }

  void _toggleTheme() {
    setState(() {
      final isDarkTheme = _themeData.brightness == Brightness.dark;
      _themeData = isDarkTheme ? ThemeData.light() : ThemeData.dark();
    });
  }

  void _toggleAppBarVisibility() {
    setState(() {
      _hideAppBarPermanently = !_hideAppBarPermanently;
      if (_hideAppBarPermanently) {
        _isAppBarVisible = true;
        _hideAppBarTimer?.cancel();
      } else {
        _showAppBar();
      }
    });
  }

  void _goToPage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sayfaya Git'),
        content: TextField(
          controller: _pageNumberController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Sayfa numarası girin'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final pageIndex = int.tryParse(_pageNumberController.text);
              if (pageIndex != null &&
                  pageIndex > 0 &&
                  pageIndex <= _filteredPages.length) {
                _pageController.jumpToPage(pageIndex - 1);
                Navigator.pop(context);
              }
            },
            child: const Text('Git'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('İptal'),
          ),
        ],
      ),
    );
  }

  void _adjustFontSize(double value) {
    setState(() {
      _fontSize = value;
      _fontSizeAnimation = Tween<double>(begin: _fontSize, end: value)
          .animate(_animationController);
      _animationController.forward(from: 0);
    });
  }

  void _showSlider() {
    setState(() {
      _isSliderVisible = true;
    });
  }

  void _hideSlider() {
    setState(() {
      _isSliderVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = _themeData.brightness == Brightness.dark;
    final Color backgroundColor = isDarkTheme ? Colors.black87 : Colors.white70;
    final searchCount = _resultIndexes.length;

    return MaterialApp(
      theme: _themeData,
      home: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: _isAppBarVisible
              ? AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      if (_isSearching) {
                        setState(() {
                          _isSearching = false;
                          _searchController.clear();
                          _filteredPages = List.from(_pages);
                        });
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  title: _isSearching
                      ? Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Ara...',
                                  hintStyle: TextStyle(
                                    color: isDarkTheme
                                        ? CustomColorScheme
                                            .darkColorScheme.onSurface
                                        : CustomColorScheme
                                            .lightColorScheme.onSurface,
                                  ),
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                  color: isDarkTheme
                                      ? CustomColorScheme
                                          .darkColorScheme.onSurface
                                      : CustomColorScheme
                                          .lightColorScheme.onSurface,
                                ),
                              ),
                            ),
                            if (searchCount > 0)
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  '(${searchCount.toString()})',
                                  style: TextStyle(
                                    color: isDarkTheme
                                        ? Colors.orange
                                        : Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        )
                      : Text(widget.fileName),
                  actions: _isSearching
                      ? [
                          IconButton(
                            icon: const Icon(JspsDepom.clear),
                            onPressed: () {
                              setState(() {
                                _isSearching = false;
                                _searchController.clear();
                                _filteredPages = List.from(_pages);
                              });
                            },
                          ),
                        ]
                      : [
                          IconButton(
                            icon: const Icon(Icons.settings),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.search),
                                      title: const Text('Ara'),
                                      onTap: () {
                                        setState(() {
                                          _isSearching = true;
                                          _isAppBarVisible =
                                              true; // Ensure AppBar is visible when searching
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        isDarkTheme
                                            ? JspsDepom.sun
                                            : JspsDepom.moon,
                                      ),
                                      title: Text(
                                        isDarkTheme
                                            ? 'Aydınlık Mod'
                                            : 'Karanlık Mod',
                                      ),
                                      onTap: () {
                                        _toggleTheme();
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        _hideAppBarPermanently
                                            ? JspsDepom.eye
                                            : JspsDepom.eyeoff,
                                      ),
                                      title: Text(
                                        _hideAppBarPermanently
                                            ? 'AppBar Gizle'
                                            : 'AppBar Göster',
                                      ),
                                      onTap: () {
                                        _toggleAppBarVisibility();
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.text_fields),
                                      title: const Text('Yazı Boyutu'),
                                      subtitle: Slider(
                                        value: _fontSize,
                                        min: 10,
                                        max: 100,
                                        divisions: 20,
                                        label: _fontSize.toString(),
                                        onChanged: (value) {
                                          _adjustFontSize(value);
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.pageview),
                                      title: const Text('Sayfaya Git'),
                                      onTap: () {
                                        _goToPage(context);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                )
              : null,
          body: FutureBuilder<void>(
            future: _loadPagesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('JSON verisi yüklenemedi veya boş'),
                );
              } else {
                return GestureDetector(
                  onTap: _showAppBar,
                  onVerticalDragStart: (details) =>
                      _showSlider(), // Slider'ı göster
                  onVerticalDragEnd: (details) =>
                      _hideSlider(), // Slider'ı gizle
                  child: Container(
                    color: backgroundColor,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentResultIndex =
                                  _resultIndexes.indexOf(index);
                              _scrollToCurrentResult();
                            });
                          },
                          itemCount: _filteredPages.length,
                          itemBuilder: (context, index) {
                            final page = _filteredPages[index];
                            final pageNumber = page.containsKey('page_number')
                                ? page['page_number']
                                : 'Belirtilmemiş';
                            final pageText = page.containsKey('text')
                                ? page['text'] as String
                                : 'Metin bulunamadı';
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: InteractiveViewer(
                                transformationController:
                                    _transformationController,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 5,
                                  color: isDarkTheme
                                      ? Colors.black54
                                      : Colors.white,
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Sayfa $pageNumber',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isDarkTheme
                                                ? Colors.white
                                                : Colors.black87,
                                            fontSize:
                                                18, // Yazı boyutunu burada ayarlayın
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        AnimatedBuilder(
                                          animation: _fontSizeAnimation,
                                          builder: (context, child) {
                                            return RichText(
                                              text: highlightText(
                                                pageText,
                                                _searchQuery,
                                                index,
                                                isDarkTheme,
                                                _fontSizeAnimation
                                                    .value, // Yazı boyutunu burada ayarlayın
                                              ),
                                              textAlign: TextAlign.justify,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        if (_isSliderVisible)
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Material(
                                elevation: 4,
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Slider(
                                    value: _fontSize,
                                    min: 10,
                                    max: 100,
                                    divisions: 20,
                                    label: _fontSize.toString(),
                                    onChanged: (value) {
                                      _adjustFontSize(value);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterPages);
    _searchController.dispose();
    _pageNumberController.dispose();
    _pageController.dispose();
    _hideAppBarTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }
}
