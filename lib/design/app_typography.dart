import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextTheme lightTextTheme = GoogleFonts.cairoTextTheme().apply(
    bodyColor: const Color(0xFF1F2937),
    displayColor: const Color(0xFF111827),
  );

  static TextTheme darkTextTheme = GoogleFonts.cairoTextTheme().apply(
    bodyColor: const Color(0xFFF9FAFB),
    displayColor: const Color(0xFFF3F4F6),
  );

  static TextStyle headlineBold(BuildContext context) {
    return Theme.of(
      context,
    ).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w700);
  }
}
