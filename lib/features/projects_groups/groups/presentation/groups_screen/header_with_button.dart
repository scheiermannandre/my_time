import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';

class HeaderWithButton extends StatelessWidget {
  final Function? onButtonPressed;
  final String title;

  final String buttonText;
  const HeaderWithButton(
      {super.key,
      required this.title,
      required this.buttonText,
      this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Groups",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 36)),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(12.5),
            backgroundColor: GlobalProperties.secondaryAccentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5), // <-- Radius
            ),
          ),
          onPressed: () {
            onButtonPressed!();
            // setState(() {
            //   if (addGroup) {
            //     if (controller.text.isNotEmpty) {
            //       groups.add(controller.text);
            //     }
            //     controller.clear();
            //     addGroup = false;
            //   } else {
            //     addGroup = true;
            //   }
            // });
          },
          child: Text(
            buttonText,
            style: const TextStyle(
                fontSize: 16, color: GlobalProperties.textAndIconColor),
          ),
        ),
      ],
    );
  }
}


// class HeaderWithButton extends StatefulWidget {
//   final Function? onButtonPressed;
//   final String title;

//   final String buttonText;
//   const HeaderWithButton(
//       {super.key,
//       required this.title,
//       required this.buttonText,
//       this.onButtonPressed});

//   @override
//   State<HeaderWithButton> createState() => _HeaderWithButtonState();
// }

// class _HeaderWithButtonState extends State<HeaderWithButton> {
//   bool isAddGroup = false;
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text("Groups",
//             style: TextStyle(fontWeight: FontWeight.w400, fontSize: 36)),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             padding: const EdgeInsets.all(12.5),
//             backgroundColor: GlobalProperties.SecondaryAccentColor,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(5), // <-- Radius
//             ),
//           ),
//           onPressed: () {
//             widget.onButtonPressed!();
//             // setState(() {
//             //   if (addGroup) {
//             //     if (controller.text.isNotEmpty) {
//             //       groups.add(controller.text);
//             //     }
//             //     controller.clear();
//             //     addGroup = false;
//             //   } else {
//             //     addGroup = true;
//             //   }
//             // });
//           },
//           child: Text(
//             !isAddGroup ? "Add Group" : "Save",
//             style: const TextStyle(
//                 fontSize: 16, color: GlobalProperties.TextAndIconColor),
//           ),
//         ),
//       ],
//     );
//   }
// }
