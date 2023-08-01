import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/constants/breakpoints.dart';

/// Widget that is displayed when no items are found.
class NoItemsFoundWidget extends StatelessWidget {
  /// Constructor for the [NoItemsFoundWidget].
  const NoItemsFoundWidget({
    required this.onBtnTap,
    required this.title,
    required this.description,
    required this.btnLabel,
    super.key,
    this.icon = Icons.add,
  });

  /// Callback that is called when the button is tapped.
  final VoidCallback onBtnTap;

  /// Title of the widget.
  final String title;

  /// Description of the widget.
  final String description;

  /// Label of the button.
  final String btnLabel;

  /// Icon of the button.
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return ResponsiveAlign(
      maxContentWidth: Breakpoint.mobile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            //Icons.wifi_off_sharp,
            Icons.search,
            size: 60,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child:
                Text(description, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              onPressed: onBtnTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      btnLabel,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Icon(
                      icon,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
