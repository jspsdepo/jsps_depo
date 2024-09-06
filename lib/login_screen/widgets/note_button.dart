import 'package:flutter/material.dart';
import 'package:jsps_depo/themes/box_decoration.dart';

class NoteButton extends StatefulWidget {
  const NoteButton({
    required this.child,
    super.key,
    this.onPressed,
    this.isOutlined = false,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final bool isOutlined;

  @override
  _NoteButtonState createState() => _NoteButtonState();
}

class _NoteButtonState extends State<NoteButton>
    with SingleTickerProviderStateMixin {
  bool _isButtonDisabled = false;
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleOnPressed() {
    if (_isButtonDisabled || widget.onPressed == null) return;
    setState(() {
      _isButtonDisabled = true;
    });

    _controller.forward(from: 0).then((_) {
      widget.onPressed!();
      setState(() {
        _isButtonDisabled = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;
    final onPrimaryColor = colorScheme.onPrimary;
    final backgroundColor =
        widget.isOutlined ? colorScheme.background : primaryColor;
    final borderColor =
        widget.isOutlined ? primaryColor : colorScheme.onSurface;

    return DecoratedBox(
      decoration: CustomBoxTheme.getBoxShadowDecoration(theme),
      child: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value * 2 * 3.1415926535, // Full circle
            child: ElevatedButton(
              onPressed: _isButtonDisabled ? null : _handleOnPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor:
                    widget.isOutlined ? primaryColor : onPrimaryColor,
                disabledBackgroundColor:
                    colorScheme.onBackground.withOpacity(0.2),
                disabledForegroundColor: colorScheme.onSurface.withOpacity(0.5),
                side: BorderSide(color: borderColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: DefaultTextStyle(
                style: theme.textTheme.labelLarge ?? const TextStyle(),
                child: widget.child,
              ),
            ),
          );
        },
      ),
    );
  }
}
