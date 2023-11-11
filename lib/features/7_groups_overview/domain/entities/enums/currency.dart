/// Enum representing different currencies.
enum Currency {
  /// United States Dollar
  dollar,

  /// Euro
  euro,

  /// British Pound Sterling
  poundSterling,

  /// Japanese Yen
  yen,

  /// French Franc
  frenchFranc,

  /// Indian Rupee
  indianRupee,

  /// South Korean Won
  southKoreanWon,

  /// Russian Ruble
  russianRuble,

  /// Thai Baht
  thaiBaht,

  /// Turkish Lira
  turkishLira,

  /// Chinese Yuan
  chineseYuan,

  /// Ukrainian Hryvnia
  ukrainianHryvnia,

  /// Laotian Kip
  laotianKip,

  /// Nigerian Naira
  nigerianNaira,

  /// Philippine Peso
  philippinePeso,

  /// South African Rand
  southAfricanRand,

  /// Israeli New Shekel
  israeliNewShekel,

  /// Mongolian Tugrik
  mongolianTugrik,

  /// Vietnamese Dong
  vietnameseDong,

  /// Zimbabwean Dollar
  zimbabweanDollar,

  /// Albanian Lek
  albanianLek,

  /// Tajikistani Somoni
  tajikistaniSomoni,

  /// Kazakhstani Tenge
  kazakhstaniTenge,

  /// Peruvian Nuevo Sol
  peruvianNuevoSol,

  /// Dominican Peso
  dominicanPeso,

  /// Paraguayan Guarani
  paraguayanGuarani,

  /// Romanian Leu
  romanianLeu,

  /// Guatemalan Quetzal
  guatemalanQuetzal,

  /// Czech Koruna
  czechKoruna,

  /// Swedish Krona
  swedishKrona,

  /// Hungarian Forint
  hungarianForint,

  /// Indonesian Rupiah
  indonesianRupiah,

  /// Belarusian Ruble
  belarusianRuble,

  /// Ghanaian Cedi
  ghanaianCedi,

  /// Costa Rican Colón
  costaRicanColon,

  /// Russian Ruble
  ruble,

  /// Bangladeshi Taka
  bangladeshiTaka,
}

/// Extension for the Currency enum.
extension CurrencyExtension on Currency {
  /// Get the label associated with the currency.
  String get label {
    switch (this) {
      case Currency.dollar:
        return r'$'; // United States Dollar
      case Currency.euro:
        return '€'; // Euro
      case Currency.poundSterling:
        return '£'; // British Pound Sterling
      case Currency.yen:
        return '¥'; // Japanese Yen
      case Currency.frenchFranc:
        return '₣'; // French Franc
      case Currency.indianRupee:
        return '₹'; // Indian Rupee
      case Currency.southKoreanWon:
        return '₩'; // South Korean Won
      case Currency.russianRuble:
        return '₽'; // Russian Ruble
      case Currency.thaiBaht:
        return '฿'; // Thai Baht
      case Currency.turkishLira:
        return '₺'; // Turkish Lira
      case Currency.chineseYuan:
        return '元'; // Chinese Yuan
      case Currency.ukrainianHryvnia:
        return '₴'; // Ukrainian Hryvnia
      case Currency.laotianKip:
        return '₭'; // Laotian Kip
      case Currency.nigerianNaira:
        return '₦'; // Nigerian Naira
      case Currency.philippinePeso:
        return '₱'; // Philippine Peso
      case Currency.southAfricanRand:
        return 'R'; // South African Rand
      case Currency.israeliNewShekel:
        return '₪'; // Israeli New Shekel
      case Currency.mongolianTugrik:
        return '₮'; // Mongolian Tugrik
      case Currency.vietnameseDong:
        return '₫'; // Vietnamese Dong
      case Currency.zimbabweanDollar:
        return 'Z'; // Zimbabwean Dollar
      case Currency.albanianLek:
        return 'L'; // Albanian Lek
      case Currency.tajikistaniSomoni:
        return 'Д'; // Tajikistani Somoni
      case Currency.kazakhstaniTenge:
        return '₸'; // Kazakhstani Tenge
      case Currency.peruvianNuevoSol:
        return 'S/.'; // Peruvian Nuevo Sol
      case Currency.dominicanPeso:
        return r'RD$'; // Dominican Peso
      case Currency.paraguayanGuarani:
        return '₲'; // Paraguayan Guarani
      case Currency.romanianLeu:
        return 'lei'; // Romanian Leu
      case Currency.guatemalanQuetzal:
        return 'Q'; // Guatemalan Quetzal
      case Currency.czechKoruna:
        return 'Kč'; // Czech Koruna
      case Currency.swedishKrona:
        return 'kr'; // Swedish Krona
      case Currency.hungarianForint:
        return 'Ft'; // Hungarian Forint
      case Currency.indonesianRupiah:
        return 'Rp'; // Indonesian Rupiah
      case Currency.belarusianRuble:
        return 'Br'; // Belarusian Ruble
      case Currency.ghanaianCedi:
        return '₵'; // Ghanaian Cedi
      case Currency.costaRicanColon:
        return '₡'; // Costa Rican Colón
      case Currency.ruble:
        return 'руб'; // Russian Ruble
      case Currency.bangladeshiTaka:
        return '৳'; // Bangladeshi Taka
    }
  }
}
