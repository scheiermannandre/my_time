import 'package:flutter/material.dart';
import 'package:my_time/common/widgets/appbar/custom_app_bar.dart';
import 'package:my_time/common/widgets/responsive_center.dart';

class GroupSettings extends StatefulWidget {
  final String groupName;
  const GroupSettings({super.key, required this.groupName});

  @override
  State<GroupSettings> createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {
  late int hours = 140;
  @override
  Widget build(BuildContext context) {
    Future<dynamic> _dialogBuilder(BuildContext context) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          TextEditingController controller = TextEditingController();
          return AlertDialog(
            title: const Text('Hours'),
            content: TextField(
              controller: controller,
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Save'),
                onPressed: () {
                  Navigator.of(context).pop(int.parse(controller.text));
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: CustomAppBar(title: "Settings"),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsiveAlign(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () async {
                  int? newHours = await _dialogBuilder(context);
                  setState(() {
                    if (newHours != null) {
                      hours = newHours;
                    }
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Planned Working Hours",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "$hours",
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
            const Divider(),
            const ListTile(
              title: Text("Export to Excel"),
              trailing: Icon(Icons.table_chart),
            )
          ],
        ),
      ),
    );
  }
}
