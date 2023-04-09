import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/constants/breakpoints.dart';

class NoItemsFoundWidget extends StatelessWidget {
  const NoItemsFoundWidget(
      {super.key,
      required this.onBtnTap,
      required this.title,
      required this.description,
      required this.btnLabel,
      this.icon = Icons.add});

  final Function() onBtnTap;
  final String title;
  final String description;
  final String btnLabel;
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
