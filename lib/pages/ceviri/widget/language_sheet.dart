import 'package:flutter/material.dart';

class LanguageSheet extends StatefulWidget {
  final Function(String) onLanguageSelected;
  final List<String> languages;

  const LanguageSheet({
    required this.onLanguageSelected,
    required this.languages,
    super.key,
  });

  @override
  State<LanguageSheet> createState() => _LanguageSheetState();
}

class _LanguageSheetState extends State<LanguageSheet> {
  final _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Container(
      height: mq.height * .5,
      padding: EdgeInsets.only(
        left: mq.width * .04,
        right: mq.width * .04,
        top: mq.height * .02,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          TextFormField(
            controller: _searchController,
            onChanged: (s) => setState(() => _searchTerm = s.toLowerCase()),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.translate_rounded, color: Colors.blue),
              hintText: 'Search Language...',
              hintStyle: TextStyle(fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: widget.languages.length,
              padding: EdgeInsets.only(top: mq.height * .02, left: 6),
              itemBuilder: (ctx, i) {
                final lang = widget.languages[i];
                if (_searchTerm.isNotEmpty &&
                    !lang.toLowerCase().contains(_searchTerm)) {
                  return const SizedBox();
                }
                return InkWell(
                  onTap: () {
                    widget.onLanguageSelected(lang);
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: mq.height * .02),
                    child: Text(lang),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
