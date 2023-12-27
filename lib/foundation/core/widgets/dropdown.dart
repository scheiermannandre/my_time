import 'package:flutter/material.dart';
import 'package:my_time/foundation/config/theme/tokens/color_tokens.dart';

const Duration _kExpand = Duration(milliseconds: 200);

/// A custom expansion tile with dropdown functionality.
class DropDownTile extends StatefulWidget {
  /// Constructs a [DropDownTile] with the required parameters.
  const DropDownTile({
    required this.initialValue,
    super.key,
    this.values = const <String>[],
    this.isExpandable = true,
    this.onValueChanged,
  });

  /// Key for the drop down icon to find in tests.
  static const dropDownIconKey = Key('dropDownIconKey');

  /// The initial value of the dropdown.
  final String? initialValue;

  /// List of values in the dropdown.
  final List<String>? values;

  /// Whether the tile is expandable.
  final bool isExpandable;

  /// Callback function called when the dropdown value changes.
  final void Function(String newValue)? onValueChanged;

  @override
  DropDownTileState createState() => DropDownTileState();
}

/// The state of the [DropDownTile].
class DropDownTileState extends State<DropDownTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _easeInAnimation;
  late Animation<double> _iconTurns;

  bool _isExpanded = false;
  bool _valueChanged = false;

  String _chosenValue = '';

  @override
  void initState() {
    super.initState();
    _chosenValue = widget.initialValue ?? '';
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _easeInAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _iconTurns = Tween<double>(begin: 0, end: 0.5).animate(_easeInAnimation);

    if (_isExpanded) {
      _controller.value = 1.0;
    }

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed && _valueChanged) {
        widget.onValueChanged?.call(_chosenValue);
        _valueChanged = false;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Toggles the visibility of the dropdown.
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
          _controller.reverse();
        }
      });
    }
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final iconColor = ThemeColorBuilder(context).getGuidingIconColor();
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              _chosenValue,
            ),
            onTap: toggle,
            trailing: widget.isExpandable
                ? RotationTransition(
                    turns: _iconTurns,
                    child: Icon(
                      key: DropDownTile.dropDownIconKey,
                      Icons.expand_more,
                      color: iconColor,
                    ),
                  )
                : const SizedBox.shrink(),
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
    final closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed
          ? null
          : ListView.builder(
              itemCount: widget.values!.length,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => ListTile(
                title: Text(
                  widget.values![index],
                ),
                onTap: () {
                  toggle();
                  setState(() {
                    _chosenValue = widget.values![index];
                    _valueChanged = true;
                  });
                },
              ),
            ),
    );
  }
}
