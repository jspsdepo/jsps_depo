import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jsps_depo/base_state.dart';
import 'package:jsps_depo/jsps_depom_icons.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({required this.apiKey, super.key});

  final String apiKey;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends BaseState<ChatWidget> {
  late final GenerativeModel _model;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode(debugLabel: 'TextField');
  bool _loading = false;
  File? _selectedImage;
  final List<({Image? image, String? text, bool fromUser})> _generatedContent =
      [];

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: widget.apiKey,
    );
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.storage,
    ].request();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          print('Image selected: ${_selectedImage!.path}');
        });
      }
    } catch (e) {
      _showError('Gallery image selection failed: $e');
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          print('Image selected from camera: ${_selectedImage!.path}');
        });
      }
    } catch (e) {
      _showError('Camera image selection failed: $e');
    }
  }

  void _removeSelectedImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _scrollDown() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 750),
          curve: Curves.easeOutCirc,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, idx) {
                final content = _generatedContent[idx];
                return MessageWidget(
                  text: content.text,
                  image: content.image,
                  isFromUser: content.fromUser,
                );
              },
              itemCount: _generatedContent.length,
            ),
          ),
          if (_selectedImage != null)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 200,
                    maxHeight: 200,
                  ),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Image.file(_selectedImage!),
                      IconButton(
                        icon: const Icon(JspsDepom.clear),
                        onPressed: _removeSelectedImage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 15,
            ),
            child: Row(
              children: [
                PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'camera') {
                      _pickImageFromCamera();
                    } else if (value == 'gallery') {
                      _pickImage();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'camera',
                      child: Row(
                        children: [
                          Icon(
                            JspsDepom.cameraalt,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          const Text('Kameradan Çek'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'gallery',
                      child: Row(
                        children: [
                          Icon(
                            JspsDepom.image,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          const Text('Galeriden Seç'),
                        ],
                      ),
                    ),
                  ],
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox.square(dimension: 15),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    focusNode: _textFieldFocus,
                    decoration: InputDecoration(
                      hintText: _selectedImage == null
                          ? 'Sohbete Başla...'
                          : 'Resim hakkında bir şeyler yazın...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    controller: _textController,
                    maxLines: 5,
                    minLines: 1,
                    onSubmitted: _sendChatMessage,
                  ),
                ),
                const SizedBox.square(dimension: 15),
                if (!_loading)
                  IconButton(
                    onPressed: () async {
                      _sendChatMessage(_textController.text);
                    },
                    icon: Icon(
                      JspsDepom.send,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                else
                  const CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendChatMessage(String message) async {
    setState(() {
      _loading = true;
    });

    try {
      if (_selectedImage != null) {
        final imageBytes = await _selectedImage!.readAsBytes();
        final content = Content.multi([
          TextPart(message),
          DataPart('image/png', imageBytes),
        ]);

        final response = await _model.generateContent([content]);
        print('Response received: ${response.text}');

        setState(() {
          _generatedContent.add(
            (image: Image.file(_selectedImage!), text: message, fromUser: true),
          );
          _generatedContent.add(
            (
              image: null,
              text: response.text ?? 'No response text',
              fromUser: false
            ),
          );
          _selectedImage = null;
          _scrollDown();
        });
      } else {
        final response = await _model.generateContent([
          Content.text(message),
        ]);
        print('Response received: ${response.text}');

        setState(() {
          _generatedContent.add((image: null, text: message, fromUser: true));
          _generatedContent.add(
            (
              image: null,
              text: response.text ?? 'No response text',
              fromUser: false
            ),
          );
          _scrollDown();
        });
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() {
        _loading = false;
        _textController.clear();
        _textFieldFocus.requestFocus();
      });
    }
  }

  void _showError(String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    required this.isFromUser,
    super.key,
    this.image,
    this.text,
  });

  final Image? image;
  final String? text;
  final bool isFromUser;

  void _copyToClipboard(BuildContext context) {
    if (text != null) {
      Clipboard.setData(
        ClipboardData(text: text!),
      ); // `text!` ile null kontrolü sağlanıyor
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Metin kopyalandı!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 520),
            decoration: BoxDecoration(
              color: isFromUser
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
            margin: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (text != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MarkdownBody(data: text!),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: const Icon(JspsDepom.copy),
                          onPressed: () => _copyToClipboard(context),
                        ),
                      ),
                    ],
                  ),
                if (image != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: image,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
