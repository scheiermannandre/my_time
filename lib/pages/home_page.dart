import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:my_time/widgets/custom_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showStartTime = false;
  DateTime startTime = DateTime(0);
  bool showEndTime = false;
  DateTime endTime = DateTime(0);
  static const String btnStringStart = "Start Time";
  static const String btnStringEnd = "Stop Time";
  static const String btnStringSave = "Save Time";

  String btnText = btnStringStart;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text("MyTime Project Time Tracker"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            showStartTime
                ? SizedBox(width: 200, child: Text("Start: $startTime"))
                : Container(),
            showEndTime
                ? SizedBox(width: 200, child: Text("End: $endTime"))
                : Container(),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (!showStartTime && !showEndTime) {
                      showStartTime = true;
                      startTime = DateTime.now().toUtc();
                      btnText = btnStringEnd;
                    } else if (showStartTime && !showEndTime) {
                      showEndTime = true;
                      endTime = DateTime.now().toUtc();
                      btnText = btnStringSave;
                    } else {
                      showStartTime = false;
                      showEndTime = false;
                      btnText = btnStringStart;
                    }
                  });
                },
                style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                child: Text(btnText),
              ),
            )
          ],
        ),
      ),
    );
  }
}
