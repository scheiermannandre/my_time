import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 64.0,
            child: DrawerHeader(
              decoration: BoxDecoration(),
              child: Text(""),
            ),
          ),
          ListTile(
            trailing: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
            title: const Text(
              "Settings",
              style: TextStyle(color: Colors.black),
            ),
            onTap: () async {},
          ),
        ],
      ),
    );
  }
}
