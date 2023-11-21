// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:my_time/common/common.dart';
// import 'package:my_time/features/1_groups/1_groups.dart';

// import 'test_robot.dart';

// class GroupScreenBottomSheetRobot {
//   GroupScreenBottomSheetRobot(this.tester);
//   final WidgetTester tester;

//   Future<void> expectIsOpen() async {
//     final bottomSheet = find.byKey(bottomSheetKey);
//     final termsOfUseListTile =
// find.byKey(GroupsScreenController.termsOfUseKey);
//     final privacyPolicyListTile =
//         find.byKey(GroupsScreenController.privacyPolicyKey);
//     final thirdPartyLicensesListTile =
//         find.byKey(GroupsScreenController.thirdPartyLicenseKey);
//     expect(
//       bottomSheet,
//       findsOneWidget,
//     );
//     expect(
//       termsOfUseListTile,
//       findsOneWidget,
//     );
//     expect(
//       privacyPolicyListTile,
//       findsOneWidget,
//     );
//     expect(
//       thirdPartyLicensesListTile,
//       findsOneWidget,
//     );
//   }

//   Future<void> close() async {
//     final bottomSheet = find.byKey(bottomSheetKey);
//     expect(
//       bottomSheet,
//       findsOneWidget,
//     );
//     await TestRobot.dragCloseWidget(
//       tester,
//       bottomSheet,
//       const Offset(0, 500),
//     );
//     expect(
//       bottomSheet,
//       findsNothing,
//     );
//   }

//   Future<void> expectPrivacyPolicyIsWorking() async {
//     final privacyPolicyListTile =
//         find.byKey(GroupsScreenController.privacyPolicyKey);
//     await _openAndClosePolicyDialog(privacyPolicyListTile);
//   }

//   Future<void> expectTermsOfUseIsWorking() async {
//     final termsOfUseListTile =
// find.byKey(GroupsScreenController.termsOfUseKey);
//     await _openAndClosePolicyDialog(termsOfUseListTile);
//   }

//   Future<void> expectShowAboutIsWorking() async {
//     final thirdPartyLicensesListTile =
//         find.byKey(GroupsScreenController.thirdPartyLicenseKey);
//     await TestRobot.clickWidget(
//       tester,
//       thirdPartyLicensesListTile,
//       pumpAndSettle: false,
//     );
//     expect(find.byType(AboutDialog), findsOneWidget);
//     expect(find.byType(TextButton), findsNWidgets(2));

//     final closeBtn = find.text('CLOSE');
//     expect(closeBtn, findsOneWidget);
//     await TestRobot.clickWidget(
//       tester,
//       closeBtn,
//     );
//     expect(find.byType(AboutDialog), findsNothing);
//   }

//   Future<void> _openAndClosePolicyDialog(Finder widget) async {
//     await TestRobot.clickWidget(
//       tester,
//       widget,
//       pumpAndSettle: false,
//     );
//     expect(find.byType(MightyMarkDownDialog), findsOneWidget);
//     final closeBtn =
// find.byKey(MightyMarkDownDialog.closePolicyDialogBtnKey);
//     expect(closeBtn, findsOneWidget);
//     await TestRobot.clickWidget(tester, closeBtn);
//     expect(find.byType(MightyMarkDownDialog), findsNothing);
//   }
// }
