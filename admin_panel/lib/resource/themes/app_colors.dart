import 'package:flutter/material.dart';

class AppColors {
  static const Color transparent = Color(0x00000000);
  static Color lightScaffoldBackgroundColor = hexToColor('#FFFFE7');
  static Color darkScaffoldBackgroundColor = hexToColor('#2F2E2E');
  static Color primaryAppColor = hexToColor('#F8D000');
  static Color secondaryAppColor = hexToColor('#22DDA6');
  static Color white = hexToColor("#FFFFFF");
  static Color isNotSelectedNavBarColor = hexToColor('#0E0E15');
  static Color isSelectedNavBarColor = hexToColor('#F8D000');
  static Color viewAllText = hexToColor('#8084B0');
  static Color borderColor = hexToColor('#D3D4E4');
  static Color dotIndicatorColor = hexToColor('#EBEBF3');

  static const Color green50 = Color(0xFFE8FFE5);
  static const Color green600 = Color(0xFF00B207);
  static const Color gold700 = Color(0xFFA67002);
  static const Color gold50 = Color(0xFFFFFFE7);
  static const Color blue600 = Color(0xFF1C859E);
  static const Color gold600 = Color(0xFFD19D00);
  static const Color cinder500 = Color(0xFF606597);
  static const Color grey = Color(0xFFBDBDBD);
  static const Color greyDark = Color(0xFF757575);
  static const Color purple300 = Color(0xFFE0E9FF);
  static const Color purple500 = Color(0xFFEFE6FE);
  static const Color orange200 = Color(0xFFFEE7CD);
  static const Color green200 = Color(0xFFC4F2EC);
  static const Color green400 = Color(0xFFD0F5CE);
  static const Color blue200 = Color(0xFFCAEFFC);
  static const Color pink200 = Color(0xFFFEE2F2);
  static const Color cinder100 = Color(0xFFEBEBF3);
  static const Color white600 = Color(0xFF656565);
  static const Color bluePrimary = Color(0xFF004CFF);
  static const Color greyTextField =Color(0xFFA8A8A9);
  static const Color blackFont = Color(0xFF202020);
  static const Color black = Color(0xFF181A20);
  static const Color black80 = Color(0xCC000000);
  static const Color white40 = Color(0xFFF8F8F8);
  static const Color greyLight = Color(0xFFA8A8A9);
  static const Color pink = Color(0xFFF83758);
  static const Color whiteBG = Color(0xFFFDFDFD);






}

ColorFilter greyFilter = const ColorFilter.matrix(<double>[
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
]);

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
  'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

extension ColorExt on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight =
    hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}