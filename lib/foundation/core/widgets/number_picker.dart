import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:my_time/foundation/config/theme/tokens/color_tokens.dart';

/// Function that builds a text from a number.
typedef TextMapper = String Function(String numberText);

/// A widget that makes it possible to pick a number interactively.
class NumberPicker extends StatefulWidget {
  /// Constructor for the NumberPicker widget.
  NumberPicker({
    required this.minValue,
    required this.maxValue,
    required int value,
    required this.onChanged,
    super.key,
    this.itemCount = 3,
    this.step = 1,
    this.itemHeight = 50,
    this.itemWidth = 100,
    this.axis = Axis.vertical,
    this.textStyle,
    this.selectedTextStyle,
    this.haptics = false,
    this.decoration,
    this.zeroPad = false,
    this.textMapper,
    this.infiniteLoop = false,
    this.selectedColor,
  }) : value = value.clamp(minValue, maxValue);

  /// Constructor for the NumberPicker widget, that presets the selected color
  /// according to the theme.
  factory NumberPicker.styled({
    required BuildContext context,
    required int minValue,
    required int maxValue,
    required int value,
    required ValueChanged<int> onChanged,
    int itemCount = 3,
    int step = 1,
    double itemHeight = 50,
    double itemWidth = 100,
    Axis axis = Axis.vertical,
    TextStyle? textStyle,
    TextStyle? selectedTextStyle,
    bool haptics = false,
    Decoration? decoration,
    bool zeroPad = false,
    TextMapper? textMapper,
    bool infiniteLoop = false,
  }) {
    return NumberPicker(
      minValue: minValue,
      maxValue: maxValue,
      value: value,
      onChanged: onChanged,
      itemCount: itemCount,
      step: step,
      itemHeight: itemHeight,
      itemWidth: itemWidth,
      axis: axis,
      textStyle: textStyle,
      selectedTextStyle: selectedTextStyle,
      haptics: haptics,
      decoration: decoration,
      zeroPad: zeroPad,
      textMapper: textMapper,
      infiniteLoop: infiniteLoop,
      selectedColor: ThemeColorBuilder(context).getGuidingIconColor(),
    );
  }

  /// Min value user can pick
  final int minValue;

  /// Max value user can pick
  final int maxValue;

  /// Currently selected value
  final int value;

  /// Called when selected value changes
  final ValueChanged<int> onChanged;

  /// Specifies how many items should be shown - defaults to 3
  final int itemCount;

  /// Step between elements. Only for integer datePicker
  /// Examples:
  /// if step is 100 the following elements may be 100, 200, 300...
  /// if min=0, max=6, step=3, then items will be 0, 3 and 6
  /// if min=0, max=5, step=3, then items will be 0 and 3.
  final int step;

  /// height of single item in pixels
  final double itemHeight;

  /// width of single item in pixels
  final double itemWidth;

  /// Direction of scrolling
  final Axis axis;

  /// Style of non-selected numbers. If null, it uses Theme's bodyText2
  final TextStyle? textStyle;

  /// Style of non-selected numbers. If null, it uses
  /// Theme's headline5 with accentColor
  final TextStyle? selectedTextStyle;

  /// Color of selected number.
  final Color? selectedColor;

  /// Whether to trigger haptic pulses or not
  final bool haptics;

  /// Build the text of each item on the picker
  final TextMapper? textMapper;

  /// Pads displayed integer values up to the length of maxValue
  final bool zeroPad;

  /// Decoration to apply to central box where the selected value is placed
  final Decoration? decoration;

  /// Whether the picker should loop infinitely or not
  final bool infiniteLoop;

  @override
  NumberPickerState createState() => NumberPickerState();
}

/// State for the NumberPicker widget
class NumberPickerState extends State<NumberPicker> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final initialOffset =
        (widget.value - widget.minValue) ~/ widget.step * _itemExtent;
    if (widget.infiniteLoop) {
      _scrollController =
          InfiniteScrollController(initialScrollOffset: initialOffset);
    } else {
      _scrollController = ScrollController(initialScrollOffset: initialOffset);
    }
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    var indexOfMiddleElement = (_scrollController.offset / _itemExtent).round();
    if (widget.infiniteLoop) {
      indexOfMiddleElement %= _itemCount;
    } else {
      indexOfMiddleElement = indexOfMiddleElement.clamp(0, _itemCount - 1);
    }
    final intValueInTheMiddle =
        _intValueFromIndex(indexOfMiddleElement + _additionalItemsOnEachSide);

    if (widget.value != intValueInTheMiddle) {
      widget.onChanged(intValueInTheMiddle);
      if (widget.haptics) {
        HapticFeedback.selectionClick();
      }
    }
    Future.delayed(
      const Duration(milliseconds: 100),
      _maybeCenterValue,
    );
  }

  @override
  void didUpdateWidget(NumberPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _maybeCenterValue();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool get _isScrolling => _scrollController.position.isScrollingNotifier.value;

  double get _itemExtent =>
      widget.axis == Axis.vertical ? widget.itemHeight : widget.itemWidth;

  int get _itemCount => (widget.maxValue - widget.minValue) ~/ widget.step + 1;

  int get _listItemsCount => _itemCount + 2 * _additionalItemsOnEachSide;

  int get _additionalItemsOnEachSide => (widget.itemCount - 1) ~/ 2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.axis == Axis.vertical
          ? widget.itemWidth
          : widget.itemCount * widget.itemWidth,
      height: widget.axis == Axis.vertical
          ? widget.itemCount * widget.itemHeight
          : widget.itemHeight,
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (not) {
          if (not.dragDetails?.primaryVelocity == 0) {
            Future.microtask(_maybeCenterValue);
          }
          return true;
        },
        child: Stack(
          children: [
            if (widget.infiniteLoop)
              InfiniteListView.builder(
                scrollDirection: widget.axis,
                controller: _scrollController as InfiniteScrollController,
                itemExtent: _itemExtent,
                itemBuilder: _itemBuilder,
                padding: EdgeInsets.zero,
              )
            else
              ListView.builder(
                itemCount: _listItemsCount,
                scrollDirection: widget.axis,
                controller: _scrollController,
                itemExtent: _itemExtent,
                itemBuilder: _itemBuilder,
                padding: EdgeInsets.zero,
              ),
            _NumberPickerSelectedItemDecoration(
              axis: widget.axis,
              itemExtent: _itemExtent,
              decoration: widget.decoration,
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final themeData = Theme.of(context);
    final defaultStyle = widget.textStyle ?? themeData.textTheme.bodyMedium;
    final selectedStyle = widget.selectedTextStyle ??
        themeData.textTheme.headlineSmall
            ?.copyWith(color: widget.selectedColor);

    final value = _intValueFromIndex(index % _itemCount);
    final isExtra = !widget.infiniteLoop &&
        (index < _additionalItemsOnEachSide ||
            index >= _listItemsCount - _additionalItemsOnEachSide);
    final itemStyle = value == widget.value ? selectedStyle : defaultStyle;

    final child = isExtra
        ? const SizedBox.shrink()
        : Text(
            _getDisplayedValue(value),
            style: itemStyle,
          );

    return Container(
      width: widget.itemWidth,
      height: widget.itemHeight,
      alignment: Alignment.center,
      child: child,
    );
  }

  String _getDisplayedValue(int value) {
    final text = widget.zeroPad
        ? value.toString().padLeft(widget.maxValue.toString().length, '0')
        : value.toString();
    if (widget.textMapper != null) {
      return widget.textMapper!(text);
    } else {
      return text;
    }
  }

  int _intValueFromIndex(int index) {
    var value = index;
    value -= _additionalItemsOnEachSide;
    value %= _itemCount;
    return widget.minValue + value * widget.step;
  }

  void _maybeCenterValue() {
    if (_scrollController.hasClients && !_isScrolling) {
      final diff = widget.value - widget.minValue;
      var index = diff ~/ widget.step;
      if (widget.infiniteLoop) {
        final offset = _scrollController.offset + 0.5 * _itemExtent;
        final cycles = (offset / (_itemCount * _itemExtent)).floor();
        index += cycles * _itemCount;
      }
      _scrollController.animateTo(
        index * _itemExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }
}

class _NumberPickerSelectedItemDecoration extends StatelessWidget {
  const _NumberPickerSelectedItemDecoration({
    required this.axis,
    required this.itemExtent,
    required this.decoration,
  });
  final Axis axis;
  final double itemExtent;
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IgnorePointer(
        child: Container(
          width: _isVertical ? double.infinity : itemExtent,
          height: _isVertical ? itemExtent : double.infinity,
          decoration: decoration,
        ),
      ),
    );
  }

  bool get _isVertical => axis == Axis.vertical;
}
