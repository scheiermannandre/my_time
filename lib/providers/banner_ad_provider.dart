// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:my_time/ad_support/ad_state.dart';
// import 'package:my_time/providers/ad_state_provider.dart';

// // /// provider used to access the AppLocalizations object for the current locale
// // final bannerAdProvider = Provider<BannerAd?>((ref) {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   ref.state = null;
// //   final adState = ref.read(adStateProvider);
// //   adState.initialization.then((status) {
// //     ref.state = BannerAd(
// //       adUnitId: adState.bannerAdUnitId,
// //       size: AdSize.banner,
// //       request: const AdRequest(),
// //       listener: adState.adListener,
// //     )..load();
// //   });
  
// //   return ref.state;
// // });

// final bannerAdProvider = Provider.family<BannerAd?, ScreenAdUnit >((ref, adUnit) {
//   WidgetsFlutterBinding.ensureInitialized();
//   ref.state = null;
//   final adState = ref.read(adStateProvider);
//   adState.initialization.then((status) {
//     ref.state = BannerAd(
//       adUnitId: adState.bannerAdUnitId(adUnit),
//       size: AdSize.banner,
//       request: const AdRequest(),
//       listener: adState.adListener,
//     )..load();
//   });
  
//   return ref.state;
// });