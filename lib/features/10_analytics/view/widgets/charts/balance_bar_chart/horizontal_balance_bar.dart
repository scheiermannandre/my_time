import 'package:flutter/material.dart';
import 'package:my_time/features/6_group_analytics/models/balance_bar_chart_configuration.dart';
import 'package:my_time/features/6_group_analytics/models/balance_bar_item.dart';
import 'package:my_time/features/6_group_analytics/models/diagram_frame_configuration.dart';
import 'package:my_time/features/10_analytics/view/widgets/charts/balance_bar_chart/balance_bar_painter.dart';

/// The Horizontal BalanceBar
class HorizontalBalanceBar extends StatefulWidget {
  /// Creates a Horizontal BalanceBar.
  const HorizontalBalanceBar({
    required this.style,
    required this.diagramFrame,
    required this.barPadding,
    required this.barContainerHeight,
    required this.item,
    super.key,
  });

  /// The style of the HorizontalBalanceBar.
  final HorizontalBalanceBarStyle style;

  /// The configuration of the DiagramFrame.
  final DiagrammFrameConfiguration diagramFrame;

  /// The padding of the bar.
  final double barPadding;

  /// The height of the bar container.
  final double barContainerHeight;

  /// The item of the HorizontalBalanceBar.
  final BalanceBarItem item;

  @override
  State<HorizontalBalanceBar> createState() => _HorizontalBalanceBarState();
}

class _HorizontalBalanceBarState extends State<HorizontalBalanceBar>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  final Tween<double> _rotationTween = Tween(begin: 0, end: 1);
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    animation = _rotationTween.animate(controller)
      ..addListener(() {
        setState(() {});
      });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.diagramFrame.axisPoints.first.dx,
      top: 0,
      right: widget.diagramFrame.endLabelCenterWidth,
      bottom: widget.barPadding * 2,
      child: Container(
        width: widget.diagramFrame.innerDiagramWidth,
        height: widget.barContainerHeight,
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: widget.barPadding),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          child: CustomPaint(
            painter: BalanceBarPainter(
              animationValue: animation.value,
              configuration: BalanceBarPainterConfiguration(
                item: widget.item,
                style: widget.style,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
