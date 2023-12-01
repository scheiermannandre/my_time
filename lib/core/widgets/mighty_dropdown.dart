import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/util/extentions/widget_ref_extension.dart';
import 'package:my_time/core/widgets/mighty_splash_list_tile.dart';

const Duration _kExpand = Duration(milliseconds: 200);

/// A customizable dropdown widget with theme-adaptive styling.
class MightyDropDown extends ConsumerWidget {
  /// Constructs a [MightyDropDown] with the required parameters.
  const MightyDropDown({
    required this.items,
    required this.onValueChanged,
    this.initialValue,
    super.key,
  });

  /// The initial value of the dropdown.
  final String? initialValue;

  /// The list of items in the dropdown.
  final List<String> items;

  /// Callback function called when the dropdown value changes.
  final void Function(String newValue)? onValueChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtain theme information from the state provider
    final theme = ref.watchStateProvider(
      context,
      mightyThemeControllerProvider,
      mightyThemeControllerProvider.notifier,
    );

    return DropDownTile(
      horizontalPadding: SpaceTokens.medium,
      textStyle: theme.controller.alternateBody,
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.controller.nonDecorativeBorderColor,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      iconColor: theme.controller.themeMode == SystemThemeMode.light
          ? theme.controller.secondaryTextColor
          : theme.controller.actionsColor,
      initialValue: initialValue ?? '',
      values: items,
      onValueChanged: onValueChanged,
    );
  }
}

/// A custom expansion tile with dropdown functionality.
class DropDownTile extends StatefulWidget {
  /// Constructs a [DropDownTile] with the required parameters.
  const DropDownTile({
    required this.initialValue,
    required this.decoration,
    required this.horizontalPadding,
    required this.iconColor,
    required this.textStyle,
    super.key,
    this.backgroundColor,
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

  /// Background color of the dropdown tile.
  final Color? backgroundColor;

  /// Icon color of the dropdown.
  final Color? iconColor;

  /// Whether the tile is expandable.
  final bool isExpandable;

  /// Decoration of the tile.
  final BoxDecoration decoration;

  /// Content padding of the tile.
  final double horizontalPadding;

  /// Text style for the dropdown.
  final TextStyle? textStyle;

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
    return Container(
      decoration: widget.decoration,
      child: Column(
        children: <Widget>[
          SplashListTile(
            title: Text(
              _chosenValue,
              style: widget.textStyle,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: widget.horizontalPadding,
            ),
            onPressed: toggle,
            trailingIcon: widget.isExpandable
                ? RotationTransition(
                    turns: _iconTurns,
                    child: Icon(
                      key: DropDownTile.dropDownIconKey,
                      Icons.expand_more,
                      size: 24,
                      color: widget.iconColor,
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
              itemBuilder: (context, index) => SplashListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: widget.horizontalPadding,
                ),
                title: Text(
                  widget.values![index],
                  style: widget.textStyle,
                ),
                onPressed: () {
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
