import 'package:flutter/material.dart';
import 'package:my_time/layers/presentation/0_home_screen/rounded_labeled_button.dart';
import 'package:my_time/layers/presentation/0_home_screen/scrollable_rounded_button_row.dart';
import 'package:my_time/global/globals.dart';
import 'package:shimmer/shimmer.dart';

class GroupsListLoadingState extends StatelessWidget {
  const GroupsListLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Shimmer.fromColors(
            period: const Duration(seconds: 1),
            direction: ShimmerDirection.ltr,
            baseColor: Colors.grey[300] as Color,
            highlightColor: Colors.grey[200]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScrollableRoundendButtonRow(
                  children: [
                    RoundedLabeldButton(
                      icon: Icons.category,
                      text: "",
                      onPressed: () {},
                    ),
                    RoundedLabeldButton(
                      icon: Icons.work,
                      text: "",
                      onPressed: () {},
                    ),
                  ],
                ),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: GlobalProperties.shadowColor,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      child: Container(
                          color: Colors.white,
                          child: const Text(
                            "",
                            style: TextStyle(fontSize: 22),
                          )),
                    ),
                  ),
                  itemCount: 6,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
