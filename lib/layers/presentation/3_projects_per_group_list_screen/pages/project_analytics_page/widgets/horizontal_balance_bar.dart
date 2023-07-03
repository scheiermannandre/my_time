// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/models/balance_bar_chart_configuration.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/models/balance_bar_item.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/models/diagram_frame_configuration.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/painters/balance_bar_painter.dart';

class HorizontalBalanceBar extends StatefulWidget {
  const HorizontalBalanceBar({
    Key? key,
    required this.style,
    required this.diagramFrame,
    required this.barPadding,
    required this.barContainerHeight,
    required this.item,
  }) : super(key: key);

  final HorizontalBalanceBarStyle style;
  final DiagrammFrameConfiguration diagramFrame;
  final double barPadding;
  final double barContainerHeight;
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
      duration: const Duration(milliseconds: 1000),
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
            topLeft: Radius.zero,
            bottomLeft: Radius.zero,
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          child: CustomPaint(
            painter: BalanceBarPainter(
              animationValue: animation.value,
              configuration: BalanceBarPainterConfiguration(
                  item: widget.item, style: widget.style),
            ),
          ),
        ),
      ),
    );
  }
}
