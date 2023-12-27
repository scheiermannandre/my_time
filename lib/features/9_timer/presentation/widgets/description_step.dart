import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/widgets/text_input_field.dart';

/// Step for entering a description.
class DescriptionField extends StatefulHookWidget {
  /// Constructor for the DescriptionStep widget.
  const DescriptionField({
    required this.save,
    required this.data,
    super.key,
  });

  /// The data of the step.
  final String? data;

  /// The function to save the data of the step.
  final void Function(String value) save;

  @override
  State<StatefulHookWidget> createState() => _DescriptionStepState();
}

class _DescriptionStepState extends State<DescriptionField> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.save(widget.data ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController(text: widget.data ?? '');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
      child: TextInputField(
        maxLines: 10,
        onChanged: (value, isValid) => widget.save(value),
        controller: textController,
        autofocus: widget.data == null,
        onEditingComplete: () => FocusScope.of(context).unfocus(),
      ),
    );
  }
}
