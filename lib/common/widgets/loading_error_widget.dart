import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/constants/breakpoints.dart';

class LoadingErrorWidget extends StatelessWidget {
  final VoidCallback onRefresh;
  const LoadingErrorWidget({super.key, required this.onRefresh});

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
            Icons.error_outline,
            size: 60,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              context.loc.loadingErrorWidgetTitle,
              style: Theme.of(context).textTheme.titleLarge,
              //const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(context.loc.loadingErrorWidgetDescription,
                style: Theme.of(context).textTheme.bodyLarge
                //const TextStyle(fontSize: 16),
                ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              onPressed: () => onRefresh(),
              //state.refreshIndicatorKey.currentState?.show(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.loc.loadingErrorWidgetBtnLabel,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Icon(
                      Icons.autorenew,
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
