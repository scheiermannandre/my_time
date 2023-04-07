import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/constants/breakpoints.dart';
import 'package:my_time/global/globals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              AppLocalizations.of(context)!.loadingErrorWidgetTitle,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              AppLocalizations.of(context)!.loadingErrorWidgetDescription,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              onPressed: () => onRefresh(),
              //state.refreshIndicatorKey.currentState?.show(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(0, 12.5, 0, 12.5),
                backgroundColor: GlobalProperties.secondaryAccentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // <-- Radius
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.loadingErrorWidgetBtnLabel,
                      style: const TextStyle(
                          color: GlobalProperties.textAndIconColor,
                          fontSize: 18),
                    ),
                    const Icon(
                      Icons.autorenew,
                      color: GlobalProperties.textAndIconColor,
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
