import 'package:flutter/material.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/constants/constants.dart';
import 'package:my_time/global/globals.dart';

/// The loading state of the LabeledBlock.
class LabeledBlockLoadingState extends StatelessWidget {
  /// Creates a LabeledBlockLoadingState.
  const LabeledBlockLoadingState({super.key});
  @override
  Widget build(BuildContext context) {
    return ResponsiveAlign(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            child: Container(
              color: Colors.grey,
              width: 200,
              height: gapH28.height,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            child: ColoredBox(
              color: Colors.grey,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, index) => const ResponsiveAlign(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(''),
                          Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 0)),
                          Row(
                            children: [
                              Text(
                                '',
                              ),
                              Text(
                                ' - ',
                              ),
                              Text(
                                '',
                              ),
                            ],
                          )
                        ],
                      ),
                      Text(
                        '',
                      ),
                    ],
                  ),
                ),
                separatorBuilder: (context, index) => Divider(
                  color: GlobalProperties.shadowColor,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
