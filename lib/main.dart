import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/pages/home_page.dart';
import 'package:my_time/pages/settings_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
      //home: const HomePage(),
    );
  }

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) =>  HomePage(),
        routes: [
          GoRoute(
            path: "settings",
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
}

// class SamplePage extends StatelessWidget {
//   static const _kBasePadding = 16.0;
//   static const kExpandedHeight = 250.0;

//   final ValueNotifier<double> _titlePaddingNotifier = ValueNotifier(_kBasePadding);

//   final _scrollController = ScrollController();

//   double get _horizontalTitlePadding {
//     const kCollapsedPadding = 0.0;

//     if (_scrollController.hasClients) {
//       return min(_kBasePadding + kCollapsedPadding,
//           _kBasePadding + (kCollapsedPadding * _scrollController.offset)/(kExpandedHeight - kToolbarHeight));
//     }

//     return _kBasePadding;
//   }

//   @override
//   Widget build(BuildContext context) {
//     _scrollController.addListener(() {
//       _titlePaddingNotifier.value = _horizontalTitlePadding;
//     });

//     return Scaffold(

//       body: NestedScrollView(
//           controller: _scrollController,
//           headerSliverBuilder: (context, innerBoxIsScrolled) {
//             return <Widget>[
//               SliverAppBar(
//                 automaticallyImplyLeading: true,
//                 leading: Icon(Icons.arrow_back),
//                   expandedHeight: kExpandedHeight,
//                   floating: false,
//                   pinned: true,
//                   flexibleSpace: FlexibleSpaceBar(

//                       collapseMode: CollapseMode.pin,
//                       centerTitle: false,
//                       titlePadding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
//                       title: ValueListenableBuilder(
//                         valueListenable: _titlePaddingNotifier,
//                         builder: (context, value, child) {
//                           return Padding(
//                             padding: EdgeInsets.symmetric(horizontal: value),
//                             child: Text(
//                               "Title"),
//                           );
//                         },
//                       ),
//                       background: Container(color: Colors.green)
//                   )
//               ),
//             ];
//           },
//           body: Text("Body text")
//         ),
//     );
//   }
// }

// class Test extends StatefulWidget {
//   @override
//   _TestState createState() => _TestState();
// }

// class _TestState extends State<Test> {
//   double rating = 3.5;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         children: ListTile
//             .divideTiles(
//               context: context,
//               tiles: List.generate(42, (index) {
//                 return SlideMenu(
//                   menuItems: <Widget>[
//                     Container(
//                       child: IconButton(
//                         icon: Icon(Icons.delete), onPressed: () {  },
//                       ),
//                     ),
//                     Container(
//                       child:  IconButton(
//                         icon: Icon(Icons.info), onPressed: () {  },
//                       ),
//                     ),
//                   ],
//                   child: ListTile(
//                     title: Container(child: Text("Drag me")),
//                   ),
//                 );
//               }),
//             )
//             .toList(),
//       ),
//     );
//   }
// }

// class SlideMenu extends StatefulWidget {
//   late Widget? child;
//   late List<Widget>? menuItems;

//   SlideMenu({this.child, this.menuItems});

//   @override
//   _SlideMenuState createState() => _SlideMenuState();
// }

// class _SlideMenuState extends State<SlideMenu> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
//   }

//   @override
//   dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final animation =  Tween(
//       begin: const Offset(0.0, 0.0),
//       end: const Offset(-0.2, 0.0)
//     ).animate( CurveTween(curve: Curves.decelerate).animate(_controller));

//     return  GestureDetector(
//       onHorizontalDragUpdate: (data) {
//         // we can access context.size here
//         setState(() {
//           _controller.value -= (data.primaryDelta! / context.size!.width)!;
//         });
//       },
//       onHorizontalDragEnd: (data) {
//         if (data.primaryVelocity! > 2500)
//           _controller.animateTo(.0); //close menu on fast swipe in the right direction
//         else if (_controller.value >= .5 || data.primaryVelocity! < -2500) // fully open if dragged a lot to left or on fast swipe to left
//           _controller.animateTo(1.0);
//         else // close if none of above
//           _controller.animateTo(.0);
//       },
//       child:  Stack(
//         children: <Widget>[
//            SlideTransition(position: animation, child: widget.child),
//            Positioned.fill(
//             child:  LayoutBuilder(
//               builder: (context, constraint) {
//                 return  AnimatedBuilder(
//                   animation: _controller,
//                   builder: (context, child) {
//                     return  Stack(
//                       children: <Widget>[
//                          Positioned(
//                           right: .0,
//                           top: .0,
//                           bottom: .0,
//                           width: constraint.maxWidth * animation.value.dx * -1,
//                           child:  Container(
//                             color: Colors.black26,
//                             child:  Row(
//                               children: widget.menuItems!.map((child) {
//                                 return  Expanded(
//                                   child: child,
//                                 );
//                               }).toList(),
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';

// // void main() {
// //   runApp(
// //     MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'Flutter Demo',
// //       home: HomePage(),
// //     ),
// //   );
// // }

// // class HomePage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Test(),
// //     );
// //   }
// // }

// // class Test extends StatefulWidget {
// //   @override
// //   _TestState createState() => _TestState();
// // }

// // class _TestState extends State<Test> {
// //   static const Radius _borderRadius = const Radius.circular(65.0);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Stack(
// //         children: [
// //           Center(
// //             child: Container(
// //               width: 300,
// //               height: 200,
// //               decoration: BoxDecoration(
// //                 border: Border.all(color: Colors.red, width: 3),
// //                 borderRadius: BorderRadius.all(_borderRadius),
// //                 color: Colors.white,
// //               ),
// //             ),
// //           ),
// //           Dismissible(
// //             key: ValueKey("hmm"),
// //             child: Center(
// //               child: Container(
// //                 width: 300,
// //                 height: 200,
// //                 decoration: const BoxDecoration(
// //                   borderRadius: BorderRadius.all(_borderRadius),
// //                   gradient: LinearGradient(
// //                     colors: [Colors.blue, Colors.pink],
// //                     begin: Alignment.topCenter,
// //                     end: Alignment.bottomCenter,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Demo"),
//       ),
//       body:
//        Center(
//         child: Column(
//           children: <Widget>[
//             RotationTransition(
//               turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
//               child: Icon(Icons.delete),
//             ),
//             ElevatedButton(
//               child: Text("go"),
//               onPressed: () => _controller.forward(),
//             ),
//             ElevatedButton(
//               child: Text("reset"),
//               onPressed: () => _controller.reset(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// Source code for this tutorial:
// https://codewithandrea.com/articles/shake-text-effect-flutter/



// import 'dart:math';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.indigo,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Shake'),
//         ),
//         body: Padding(padding: const EdgeInsets.all(32.0), child: MyHomePage()),
//       ),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   MyHomePage({Key? key}) : super(key: key);
//   // 1. declare a GlobalKey
//   final shakeKey = GlobalKey<ShakeWidgetState>();

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SizedBox(
//         width: 300,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(height: 16),
//             TextField(
//               controller: TextEditingController(text: 'abc@email.com'),
//               decoration: InputDecoration(hintText: 'Email address'),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: TextEditingController(text: '1234'),
//               obscureText: true,
//               decoration: InputDecoration(hintText: 'Password'),
//             ),
//             SizedBox(height: 16),
//             SizedBox(
//               height: 48,
//               // 2. shake the widget via the GlobalKey when a button is pressed
//               child: ElevatedButton(
//                 child: Text('Sign In', style: TextStyle(fontSize: 20)),
//                 onPressed: () => shakeKey.currentState?.shake(),
//               ),
//             ),
//             SizedBox(height: 16),
//             // 3. Add a parent ShakeWidget to the child widget we want to animate
//             ShakeWidget(
//               // 4. pass the GlobalKey as an argument
//               key: shakeKey,
//               // 5. configure the animation parameters
//               shakeCount: 2,
//               shakeOffset: 10,
//               shakeDuration: Duration(milliseconds: 1000),
//               // 6. Add the child widget that will be animated
//               child: Icon(Icons.delete),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// abstract class AnimationControllerState<T extends StatefulWidget>
//     extends State<T> with SingleTickerProviderStateMixin {
//   AnimationControllerState(this.animationDuration);
//   final Duration animationDuration;
//   late final animationController =
//       AnimationController(vsync: this, duration: animationDuration);

//   @override
//   void dispose() {
//     animationController.dispose();
//     super.dispose();
//   }
// }

// class ShakeWidget extends StatefulWidget {
//   const ShakeWidget({
//     Key? key,
//     required this.child,
//     required this.shakeOffset,
//     this.shakeCount = 10,
//     this.shakeDuration = const Duration(milliseconds: 400),
//   }) : super(key: key);
//   final Widget child;
//   final double shakeOffset;
//   final int shakeCount;
//   final Duration shakeDuration;

//   @override
//   ShakeWidgetState createState() => ShakeWidgetState(shakeDuration);
// }

// class ShakeWidgetState extends AnimationControllerState<ShakeWidget> {
//   ShakeWidgetState(Duration duration) : super(duration);

//   @override
//   void initState() {
//     super.initState();
//     animationController.addStatusListener(_updateStatus);
//   }

//   @override
//   void dispose() {
//     animationController.removeStatusListener(_updateStatus);
//     super.dispose();
//   }

//   void _updateStatus(AnimationStatus status) {
//     if (status == AnimationStatus.completed) {
//       animationController.reset();
//     }
//   }

//   void shake() {
//     animationController.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: animationController,
//       child: widget.child,
//       builder: (context, child) {
//         final sineValue =
//             sin(widget.shakeCount * 2 * pi * animationController.value);
//         return Transform.rotate(
//           angle: sineValue,
//           child: child,
//         );
//       },
//     );
//   }
// }
