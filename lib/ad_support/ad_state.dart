// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  final Future<InitializationStatus> initialization;

  String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';
  AdState(
    this.initialization,
  );

  BannerAdListener get adListener => _adListener;

  final BannerAdListener _adListener = BannerAdListener(
    onAdLoaded: (Ad ad) => print('Ad loaded. ${ad.adUnitId}'),
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
      print('Ad failed to load: ${ad.adUnitId}, $error');
    },
    onAdOpened: (Ad ad) => print('Ad opened. ${ad.adUnitId}'),
    onAdClosed: (Ad ad) => print('Ad closed.'),
    onPaidEvent: (ad, valueMicros, precision, currencyCode) => print(
      'Paid event: ${ad.adUnitId} $valueMicros, $precision, $currencyCode',
    ),
    onAdImpression: (Ad ad) => print('Ad impression. ${ad.adUnitId}'),
    onAdWillDismissScreen: (Ad ad) =>
        print('Ad will dismiss screen. ${ad.adUnitId}'),
    onAdClicked: (ad) => print('Ad Clicked. ${ad.adUnitId}'),
  );
}
