import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Clipboard için eklendi
import 'package:jsps_depo/jsps_depom_icons.dart';
import 'package:jsps_depo/pages/ceviri/custom_butn.dart';
import 'package:jsps_depo/pages/ceviri/translate_controller.dart';
import 'package:jsps_depo/pages/ceviri/widget/language_sheet.dart';
import 'package:jsps_depo/themes/box_decoration.dart';

class TranslatorFeature extends StatefulWidget {
  const TranslatorFeature({super.key});

  @override
  State<TranslatorFeature> createState() => _TranslatorFeatureState();
}

class _TranslatorFeatureState extends State<TranslatorFeature> {
  final TranslateController _controller = TranslateController();
  final ScrollController _inputScrollController = ScrollController();
  final ScrollController _resultScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Çeviri'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          top: mq.height * 0.02,
          bottom: mq.height * 0.1,
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => _showLanguageSheet(
                  context,
                  _controller.from,
                  _controller.jsonLang.keys.toList(),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Container(
                  height: 50,
                  width: mq.width * 0.4,
                  alignment: Alignment.center,
                  decoration:
                      CustomBoxTheme.getBoxShadowDecoration(Theme.of(context)),
                  child: ValueListenableBuilder(
                    valueListenable: _controller.from,
                    builder: (context, value, child) {
                      return Text(value.isEmpty ? 'Dili Algıla' : value);
                    },
                  ),
                ),
              ),
              IconButton(
                onPressed: _controller.swapLanguages,
                icon: ValueListenableBuilder(
                  valueListenable: _controller.to,
                  builder: (context, value, child) {
                    return Icon(
                      Icons.repeat_on_rounded,
                      color: _controller.to.value.isNotEmpty &&
                              _controller.from.value.isNotEmpty
                          ? Colors.blue
                          : Colors.grey,
                    );
                  },
                ),
              ),
              InkWell(
                onTap: () => _showLanguageSheet(
                  context,
                  _controller.to,
                  _controller.jsonLang.keys.toList(),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Container(
                  height: 50,
                  width: mq.width * 0.4,
                  alignment: Alignment.center,
                  decoration:
                      CustomBoxTheme.getBoxShadowDecoration(Theme.of(context)),
                  child: ValueListenableBuilder(
                    valueListenable: _controller.to,
                    builder: (context, value, child) {
                      return Text(value.isEmpty ? 'To' : value);
                    },
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mq.width * 0.04,
              vertical: mq.height * 0.035,
            ),
            child: Container(
              width: double.infinity,
              height: 200, // Yükseklik sabitlenebilir
              decoration:
                  CustomBoxTheme.getBoxShadowDecoration(Theme.of(context)),
              child: SingleChildScrollView(
                controller: _inputScrollController,
                physics: const BouncingScrollPhysics(),
                child: TextFormField(
                  controller: _controller.textC,
                  minLines: 5,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'İstediğiniz her şeyi çevirin ...',
                    hintStyle: TextStyle(fontSize: 13.5),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _controller.status,
            builder: (context, value, child) {
              return _translateResult(mq.width);
            },
          ),
          SizedBox(height: mq.height * 0.04),
          CustomBtn(
            onTap: () async {
              await _controller.googleTranslate(context);
            },
            text: 'Çevir',
          ),
        ],
      ),
    );
  }

  void _showLanguageSheet(
    BuildContext context,
    ValueNotifier<String> selectedLang,
    List<String> languages,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return LanguageSheet(
          onLanguageSelected: (lang) {
            selectedLang.value = lang;
          },
          languages: languages,
        );
      },
    );
  }

  Widget _translateResult(double width) {
    final mq = MediaQuery.of(context).size;

    switch (_controller.status.value) {
      case Status.none:
        return const SizedBox();
      case Status.complete:
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * 0.04),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              decoration:
                  CustomBoxTheme.getBoxShadowDecoration(Theme.of(context)),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200, // Kartın yüksekliği ayarlanabilir
                    child: SingleChildScrollView(
                      controller: _resultScrollController,
                      physics: const BouncingScrollPhysics(),
                      child: SelectableText(
                        _controller.resultC.text,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(JspsDepom.copy),
                      onPressed: () {
                        final data =
                            ClipboardData(text: _controller.resultC.text);
                        Clipboard.setData(data);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied to clipboard')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      case Status.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return const SizedBox();
    }
  }
}
