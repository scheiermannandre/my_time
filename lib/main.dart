import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/routing/route_generator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
      //routerConfig: _router,
      //home: const Test(),
    );
  }

//   // // final GoRouter _router = GoRouter(
//   // //   routes: [
//   // //     GoRoute(
//   // //       path: "/",
//   // //       builder: (context, state) => const HomePage(),
//   // //       routes: [
//   // //         GoRoute(
//   // //             path: "newproject",
//   // //             builder: (context, state) {
//   // //               Project project = state.extra as Project;
//   // //               return NewProjectPage(project: project);
//   // //             }),
//   // //         GoRoute(
//   // //           path: "settings",
//   // //           builder: (context, state) => const SettingsPage(),
//   // //         ),
//   // //       ],
//   // //     ),
//   // //   ],
//   // // );
}

// // import 'package:flutter/material.dart';

// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Demo',
// //       theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
// //       home: ExpansionPanelDemo(),
// //     );
// //   }
// // }


// // class ExpansionPanelDemo extends StatefulWidget {
// //   ExpansionPanelDemo({Key? key}) : super(key: key);

// //   @override
// //   _ExpansionPanelDemoState createState() => _ExpansionPanelDemoState();
// // }

// // class _ExpansionPanelDemoState extends State<ExpansionPanelDemo> {
// //   List<Item> _books = generateItems(8);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SingleChildScrollView(
// //         child: Container(
// //           padding: EdgeInsets.only(top: 80),
// //           child: _buildPanel(),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildPanel() {
// //     return ExpansionPanelList(
// //       expansionCallback: (int index, bool isExpanded) {
// //         setState(() {
// //           _books[index].isExpanded = !isExpanded;
// //         });
// //       },
// //       children: _books.map<ExpansionPanel>((Item item) {
// //         return ExpansionPanel(
// //           headerBuilder: (BuildContext context, bool isExpanded) {
// //             return ListTile(
// //               title: Text(item.headerValue),
// //             );
// //           },
// //           body: ListTile(
// //             title: Text(item.expandedValue),
// //           ),
// //           isExpanded: item.isExpanded,
// //         );
// //       }).toList(),
// //     );
// //   }
// // }

// // // stores ExpansionPanel state information
// // class Item {
// //   Item({
// //     required this.expandedValue,
// //     required this.headerValue,
// //     this.isExpanded = false,
// //   });

// //   String expandedValue;
// //   String headerValue;
// //   bool isExpanded;
// // }

// // List<Item> generateItems(int numberOfItems) {
// //   return List.generate(numberOfItems, (int index) {
// //     return Item(
// //       headerValue: 'Book $index',
// //       expandedValue: 'Details for Book $index goes here',
// //     );
// //   });
// // }

// import 'package:flutter/material.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:line_icons/line_icons.dart';

// void main() => runApp(MaterialApp(
//     builder: (context, child) {
//       return Directionality(textDirection: TextDirection.ltr, child: child!);
//     },
//     title: 'GNav',
//     theme: ThemeData(
//       primaryColor: Colors.grey[800],
//     ),
//     home: Example()));

// class Example extends StatefulWidget {
//   @override
//   _ExampleState createState() => _ExampleState();
// }

// class _ExampleState extends State<Example> {
//   int _selectedIndex = 0;
//   static const TextStyle optionStyle =
//       TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
//   static const List<Widget> _widgetOptions = <Widget>[
//     Text(
//       'Home',
//       style: optionStyle,
//     ),
//     Text(
//       'Likes',
//       style: optionStyle,
//     ),
//     Text(
//       'Search',
//       style: optionStyle,
//     ),
//     Text(
//       'Profile',
//       style: optionStyle,
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 20,
//         title: const Text('GoogleNavBar'),
//       ),
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 20,
//               color: Colors.black.withOpacity(.1),
//             )
//           ],
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
//             child: GNav(
//               rippleColor: Colors.grey[300]!,
//               hoverColor: Colors.grey[100]!,
//               gap: 8,
//               activeColor: Colors.black,
//               iconSize: 24,
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               duration: Duration(milliseconds: 400),
//               tabBackgroundColor: Colors.grey[100]!,
//               color: Colors.black,
//               tabs: [
//                 GButton(
//                   icon: Icons.home,
//                   text: 'Home',
//                 ),
//                 GButton(
//                   icon: Icons.library_add_check_rounded,
//                   text: 'Likes',
//                 ),
//                 GButton(
//                   icon: Icons.search,
//                   text: 'Search',
//                 ),
//                 GButton(
//                   icon: Icons.usb_rounded,
//                   text: 'Profile',
//                 ),
//               ],
//               selectedIndex: _selectedIndex,
//               onTabChange: (index) {
//                 setState(() {
//                   _selectedIndex = index;
//                 });
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
