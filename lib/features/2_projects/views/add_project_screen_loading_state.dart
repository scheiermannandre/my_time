import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';
import 'package:shimmer/shimmer.dart';

/// Loading state for the AddProjectScreen.
class AddProjectScreenLoadingState extends StatelessWidget {
  /// Constructor for the [AddProjectScreenLoadingState].
  const AddProjectScreenLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Shimmer.fromColors(
          period: const Duration(seconds: 1),
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[200]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
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
                  padding: const EdgeInsets.fromLTRB(0, 12, 200, 0),
                  child: const ColoredBox(
                    color: Colors.white,
                    child: Text(
                      '',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  width: double.infinity,
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
                  child: const ColoredBox(
                    color: Colors.white,
                    child: Text(
                      '',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
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
                  padding: const EdgeInsets.fromLTRB(0, 12, 200, 0),
                  child: const ColoredBox(
                    color: Colors.white,
                    child: Text(
                      '',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  width: double.infinity,
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
                  child: const ColoredBox(
                    color: Colors.white,
                    child: Text(
                      '',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
