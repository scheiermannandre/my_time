import 'package:flutter/material.dart';

const Duration _kExpand = Duration(milliseconds: 200);

/// A custom expansion tile.
class CustomExpansionTile extends StatefulWidget {
  /// Constructor for the [CustomExpansionTile].
  const CustomExpansionTile({
    required this.title,
    required this.decoration,
    required this.contentPadding,
    super.key,
    this.leading,
    this.backgroundColor,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.initiallyExpanded = false,
    this.isExpandable = true,
  });

  /// Leading widget.
  final Widget? leading;

  /// Title widget.
  final Widget? title;

  /// Callback for when the expansion state changes.
  final ValueChanged<bool>? onExpansionChanged;

  /// List of children widgets.
  final List<Widget>? children;

  /// Background color of the tile.
  final Color? backgroundColor;

  /// Trailing widget.
  final Widget? trailing;

  /// Whether the tile is initially expanded.
  final bool initiallyExpanded;

  /// Whether the tile is expandable.
  final bool isExpandable;

  /// Decoration of the tile.
  final BoxDecoration decoration;

  /// Content padding of the tile.
  final EdgeInsets contentPadding;

  @override
  CustomExpansionTileState createState() => CustomExpansionTileState();
}

/// The state of the [CustomExpansionTile].
class CustomExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _easeInAnimation;
  late ColorTween _borderColor;
  late ColorTween _headerColor;
  late ColorTween _iconColor;
  late ColorTween _backgroundColor;
  late Animation<double> _iconTurns;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _easeInAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _borderColor = ColorTween();
    _headerColor = ColorTween();
    _iconColor = ColorTween();
    _iconTurns = Tween<double>(begin: 0, end: 0.5).animate(_easeInAnimation);
    _backgroundColor = ColorTween();

    _isExpanded = widget.initiallyExpanded;
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Expands the tile.
  void expand() {
    _setExpanded(true);
  }

  /// Collapses the tile.
  void collapse() {
    _setExpanded(false);
  }

  /// Toggles the tile.
  void toggle() {
    _setExpanded(!_isExpanded);
  }

  void _setExpanded(bool isExpanded) {
    if (!widget.isExpandable) {
      return;
    }
    if (_isExpanded != isExpanded) {
      setState(() {
        _isExpanded = isExpanded;
        if (_isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse().then<void>((void value) {
            setState(() {});
          });
        }
        PageStorage.of(context).writeState(context, _isExpanded);
      });
      widget.onExpansionChanged?.call(_isExpanded);
    }
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    return Container(
      decoration: widget.decoration,
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: toggle,
            child: Padding(
              padding: widget.contentPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: widget.title,
                  ),
                  if (widget.isExpandable)
                    RotationTransition(
                      turns: _iconTurns,
                      child: const Icon(
                        Icons.expand_more,
                        size: 24,
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
            ),
          ),
          ClipRect(
            child: Align(
              heightFactor: _easeInAnimation.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _borderColor.end = theme.dividerColor;
    _headerColor
      ..begin = theme.textTheme.titleMedium!.color
      ..end = theme.colorScheme.secondary;
    _iconColor
      ..begin = theme.unselectedWidgetColor
      ..end = theme.colorScheme.secondary;
    _backgroundColor.end = widget.backgroundColor;

    final closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children!),
    );
  }
}
