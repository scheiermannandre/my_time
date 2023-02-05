import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/common/widgets/async_value_widget.dart';
import 'package:my_time/common/widgets/responsive_center.dart';
import 'package:my_time/common/widgets/standard_button.dart';
import 'package:my_time/features/projects_groups/groups/data/groups_repository.dart';
import 'package:my_time/features/projects_groups/projects/domain/project.dart';
import 'package:my_time/features/projects_groups/projects/presentation/new_project_screen/dropdown_menu.dart';
import 'package:my_time/features/projects_groups/projects/presentation/new_project_screen/styled_text_form_field.dart';
import 'package:my_time/global/globals.dart';

class NewProjectScreen extends StatefulWidget {
  // late List<String> groups = [];
  const NewProjectScreen({
    super.key,
  });

  @override
  State<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen>
    with TickerProviderStateMixin {
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late String _projectName;
  late String _category;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController controller = TextEditingController();
  TextEditingController dropDownSelectionController = TextEditingController();
  EdgeInsets padding = const EdgeInsets.fromLTRB(10, 10, 10, 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: GlobalProperties.textAndIconColor,
          ),
        ),
        backgroundColor: GlobalProperties.backgroundColor,
      ),
      backgroundColor: GlobalProperties.backgroundColor,
      body: ResponsiveAlign(
        padding: padding,
        alignment: Alignment.topCenter,
        child: Consumer(
          builder: (context, ref, child) {
            final groupsListValue = ref.watch(groupsListStreamProvider);
            return AsyncValueWidget(
              value: groupsListValue,
              data: (groups) => groups.isEmpty
                  ? Center(
                      child: Text(
                        'No groups found',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    )
                  : CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Form(
                                key: _formKey,
                                child: Column(children: [
                                  StyledTextFormField(
                                    controller: controller,
                                    label: "Project Name",
                                    validator: ((value) {
                                      if (value!.isEmpty) {
                                        return "Project Name required!";
                                      }
                                      return null;
                                    }),
                                    onSaved: (newValue) {
                                      _projectName = newValue!;
                                    },
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                  DropDownMenuTextFormField(
                                    label: "Group",
                                    validator: ((value) {
                                      if (value!.isEmpty) {
                                        return "Group required!";
                                      }
                                      return null;
                                    }),
                                    onSaved: (newValue) {
                                      _category = newValue!;
                                    },
                                    dropDownSelectionController:
                                        dropDownSelectionController,
                                    items: groups
                                        .map((group) => group.name)
                                        .toList(),
                                  ),
                                ]),
                              ),
                              const Spacer(),
                              StandardButton(
                                text: "Create",
                                onPressed: () {
                                  bool isDataValid =
                                      _formKey.currentState!.validate();
                                  if (isDataValid) {
                                    _formKey.currentState!.save();
                                    Navigator.of(context)
                                        .pop(Project(name: _projectName));
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}
